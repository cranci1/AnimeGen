//
//  DownloadManager.swift
//  Sulfur
//
//  Created by Francesco on 29/04/25.
//

import AVKit
import SwiftUI
import AVFoundation

class DownloadManager: NSObject, ObservableObject {
    @Published var activeDownloads: [(URL, Double)] = []
    @Published var localPlaybackURL: URL?
    @Published var subtitleURL: URL?
    
    private var assetDownloadURLSession: AVAssetDownloadURLSession!
    private var activeDownloadTasks: [URLSessionTask: URL] = [:]
    private var activeDownloadHeaders: [URL: [String: String]] = [:]
    private var activeSubtitleTasks: [URLSessionDownloadTask: URL] = [:]
    
    override init() {
        super.init()
        initializeDownloadSession()
        loadLocalContent()
    }
    
    private func initializeDownloadSession() {
#if targetEnvironment(simulator)
        Logger.shared.log("Download Sessions are not available on Simulator", type: "Error")
#else
        let configuration = URLSessionConfiguration.background(withIdentifier: "hls-downloader")
        
        assetDownloadURLSession = AVAssetDownloadURLSession(
            configuration: configuration,
            assetDownloadDelegate: self,
            delegateQueue: .main
        )
#endif
    }
    
    func downloadAsset(from url: URL, headers: [String: String]? = nil, subtitleURL: URL? = nil) {
        if let headers = headers {
            activeDownloadHeaders[url] = headers
        }
        
        let asset: AVURLAsset
        if let headers = headers {
            let options = [
                "AVURLAssetHTTPHeaderFieldsKey": headers
            ]
            asset = AVURLAsset(url: url, options: options)
        } else {
            asset = AVURLAsset(url: url)
        }
        
        let task = assetDownloadURLSession.makeAssetDownloadTask(
            asset: asset,
            assetTitle: "Offline Video",
            assetArtworkData: nil,
            options: nil
        )
        
        task?.resume()
        activeDownloadTasks[task!] = url
        
        if let subtitleURL = subtitleURL {
            downloadSubtitle(from: subtitleURL, headers: headers)
        }
    }
    
    private func downloadSubtitle(from url: URL, headers: [String: String]? = nil) {
        var request = URLRequest(url: url)
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        let task = URLSession.shared.downloadTask(with: request) { [weak self] location, response, error in
            guard let self = self,
                  let location = location,
                  error == nil else {
                Logger.shared.log("Subtitle download failed: \(error?.localizedDescription ?? "Unknown error")", type: "Error")
                return
            }
            
            do {
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileName = url.lastPathComponent
                let savedURL = documents.appendingPathComponent(fileName)
                
                if FileManager.default.fileExists(atPath: savedURL.path) {
                    try FileManager.default.removeItem(at: savedURL)
                }
                
                try FileManager.default.moveItem(at: location, to: savedURL)
                
                DispatchQueue.main.async {
                    self.subtitleURL = savedURL
                }
            } catch {
                Logger.shared.log("Failed to save subtitle file: \(error.localizedDescription)", type: "Error")
            }
        }
        
        activeSubtitleTasks[task] = url
        task.resume()
    }
    
    private func loadLocalContent() {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: documents,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            
            if let localURL = contents.first(where: { ["movpkg", "mp4"].contains($0.pathExtension.lowercased()) }) {
                localPlaybackURL = localURL
            }
        } catch {
            Logger.shared.log("Could not load local content: \(error)", type: "Error")
        }
    }
}

extension DownloadManager: AVAssetDownloadDelegate {
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        if let originalURL = activeDownloadTasks[assetDownloadTask] {
            activeDownloadTasks.removeValue(forKey: assetDownloadTask)
            activeDownloadHeaders.removeValue(forKey: originalURL)
        }
        localPlaybackURL = location
        Logger.shared.log("Asset download completed successfully", type: "Debug")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            Logger.shared.log("Download failed: \(error.localizedDescription)", type: "Error")
            
            if let originalURL = activeDownloadTasks[task] {
                activeDownloadHeaders.removeValue(forKey: originalURL)
            }
            activeDownloadTasks.removeValue(forKey: task)
            
            if let downloadTask = task as? URLSessionDownloadTask {
                activeSubtitleTasks.removeValue(forKey: downloadTask)
            }
        } else {
            Logger.shared.log("Download completed successfully", type: "Debug")
        }
    }
    
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        
        guard let url = activeDownloadTasks[assetDownloadTask] else { return }
        let progress = loadedTimeRanges
            .map { $0.timeRangeValue.duration.seconds / timeRangeExpectedToLoad.duration.seconds }
            .reduce(0, +)
        
        if let index = activeDownloads.firstIndex(where: { $0.0 == url }) {
            activeDownloads[index].1 = progress
        } else {
            activeDownloads.append((url, progress))
        }
    }
}
