//
//  ViewController.swift
//  AnimeGen
//
//  Created by Francesco on 26/01/25.
//

import UIKit
import Photos
import Kingfisher
import SafariServices

enum ImageSource: String {
    case waifuIm = "waifuIm"
    case picRe = "picRe"
    case waifupics = "waifuPics"
    case purr = "purr"
    case nekosMoe = "nekosMoe"
    case nekoBot = "nekoBot"
    case nekosApi = "nekosApi"
    case nekosBest = "nekosBest"
    case nekosLife = "nekosLife"
    case imageOnly = "Image-only"
    case gifOnly = "Gif-only"
}

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var safariButton: UIButton!
    @IBOutlet weak var sourceButton: UIButton!
    
    var currentSource: ImageSource = .waifuIm
    var imageHistory: [URL] = []
    var currentImageIndex: Int = -1
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        
        if let savedSource = UserDefaults.standard.string(forKey: "selectedSource"),
           let imageSource = ImageSource(rawValue: savedSource) {
            currentSource = imageSource
        }
        
        setupSourceButtonMenu()
        loadNewImage()
    }
    
    func setupSourceButtonMenu() {
        sourceButton.menu = createSourceMenu()
        sourceButton.showsMenuAsPrimaryAction = true
    }
    
    func createSourceMenu() -> UIMenu {
        let sources: [ImageSource] = [.waifuIm, .picRe, .waifupics, .purr, .nekosMoe, .nekoBot, .nekosApi, .nekosBest, .nekosLife, .imageOnly, .gifOnly]
        
        let actions = sources.map { source in
            UIAction(title: source.rawValue, state: (currentSource == source) ? .on : .off) { [weak self] _ in
                self?.currentSource = source
                self?.saveSelectedSource()
                self?.loadNewImage()
                self?.setupSourceButtonMenu()
            }
        }
        
        return UIMenu(title: "Select Source", children: actions)
    }
    
    func loadNewImage() {
        activityIndicator.startAnimating()
        
        DispatchQueue.main.async {
            switch self.currentSource {
            case .waifuIm:
                self.fetchImageFromWaifuIm()
            case .picRe:
                self.fetchImageFromPicRe()
            case .waifupics:
                self.fetchImageFromWaifuPics()
            case .purr:
                self.fetchImageFromPurr()
            case .nekosMoe:
                self.fetchImageFromNekosMoe()
            case .nekoBot:
                self.fetchImageFromNekoBot()
            case .nekosApi:
                self.fetchImageFromNekosApi()
            case .nekosBest:
                self.fetchImageFromNekosBest()
            case .nekosLife:
                self.fetchImageFromNekosLife()
            case .imageOnly:
                self.fetchImageFromImageOnly()
            case .gifOnly:
                self.fetchImageFromGifOnly()
            }
        }
    }
    
    func loadImage(from url: URL) {
        imageView.kf.setImage(with: url, options: [.keepCurrentImageWhileLoading]) { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success:
                if self.imageHistory.isEmpty || url != self.imageHistory.last {
                    self.imageHistory.append(url)
                }
                self.currentImageIndex = self.imageHistory.count - 1
            case .failure(let error):
                print("Error: \(error)")
                self.showErrorAlert(message: "Failed to load image.")
            }
        }
    }
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        guard currentImageIndex >= 0, currentImageIndex < imageHistory.count else {
            print("No valid image URL available")
            return
        }
        
        let currentURL = imageHistory[currentImageIndex]
        let safariVC = SFSafariViewController(url: currentURL)
        present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        loadNewImage()
    }
    
    @IBAction func rewindButtonTapped(_ sender: UIButton) {
        guard !imageHistory.isEmpty else {
            print("No images in history.")
            return
        }
        
        if currentImageIndex > 0 {
            currentImageIndex -= 1
            let previousImageUrl = imageHistory[currentImageIndex]
            self.imageView.kf.setImage(with: previousImageUrl)
        } else {
            print("first image")
        }
        
        if currentImageIndex == 0 {
            showAlert(message: "This is the first image in history.")
        }
    }
    
    func saveSelectedSource() {
        UserDefaults.standard.set(currentSource.rawValue, forKey: "selectedSource")
    }
    
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        guard currentImageIndex >= 0, currentImageIndex < imageHistory.count else {
            print("No valid image URL available")
            return
        }
        
        let currentURL = imageHistory[currentImageIndex]
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .authorized, .limited:
                DispatchQueue.main.async {
                    self.downloadAndSaveImage(from: currentURL)
                }
            case .denied, .restricted:
                print("Photo library access denied or restricted.")
                DispatchQueue.main.async {
                    self.showPhotoLibraryAccessDeniedAlert()
                }
            case .notDetermined:
                print("Photo library access not determined.")
            @unknown default:
                print("Unknown authorization status")
            }
        }
    }
    
    func downloadAndSaveImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(message: "Error downloading image: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self.showAlert(message: "No data received")
                }
                return
            }
            let isGIF = self.isGIFImage(data: data, url: url)
            
            if isGIF {
                self.saveGIFToPhotoLibrary(data: data)
            } else {
                if let image = UIImage(data: data) {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Failed to create image from data")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func isGIFImage(data: Data, url: URL) -> Bool {
        if url.pathExtension.lowercased() == "gif" {
            return true
        }
        if data.count >= 6 {
            let gifSignature = data.prefix(6)
            if gifSignature == Data([0x47, 0x49, 0x46, 0x38, 0x37, 0x61]) || // GIF87a
               gifSignature == Data([0x47, 0x49, 0x46, 0x38, 0x39, 0x61]) { // GIF89a
                return true
            }
        }
        
        return false
    }
    
    func saveGIFToPhotoLibrary(data: Data) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("temp_gif_\(UUID().uuidString).gif")
        
        do {
            try data.write(to: tempURL)
            
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .photo, fileURL: tempURL, options: nil)
            }) { [weak self] success, error in
                DispatchQueue.main.async {
                    try? FileManager.default.removeItem(at: tempURL)
                    
                    if success {
                        print("GIF saved to photo library successfully!")
                        self?.showAlert(message: "GIF saved to photo library successfully!")
                    } else if let error = error {
                        print("Error saving GIF: \(error.localizedDescription)")
                        self?.showAlert(message: "Error saving GIF: \(error.localizedDescription)")
                    } else {
                        self?.showAlert(message: "Failed to save GIF")
                    }
                }
            }
        } catch {
            print("Error writing GIF to temporary file: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.showAlert(message: "Error writing GIF to temporary file: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func imageCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
            showAlert(message: "Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved to photo library successfully!")
            showAlert(message: "Image saved to photo library successfully!")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showPhotoLibraryAccessDeniedAlert() {
        let alert = UIAlertController(
            title: "Photo Library Access Denied",
            message: "Please allow access to your photo library in Settings to save images.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
