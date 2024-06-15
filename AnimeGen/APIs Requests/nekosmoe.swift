//
//  nekosmoe.swift
//  AnimeGen
//
//  Created by cranci on 18/02/24.
//

import UIKit

extension ViewController {

    func loadImageFromNekosMoe() {
        startLoadingIndicator()
        
        let isNSFW = UserDefaults.standard.bool(forKey: "explicitContents")
        let apiEndpoint = "https://nekos.moe/api/v1/random/image"
        
        var urlComponents = URLComponents(string: apiEndpoint)
        urlComponents?.queryItems = [URLQueryItem(name: "nsfw", value: isNSFW.description.lowercased())]
        
        guard let url = urlComponents?.url else {
            handleError("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.handleError("Request error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let jsonData = data else {
                    self.handleError("Invalid response or data.")
                    return
                }
                
                self.handleImageData(jsonData)
            }
        }
        task.resume()
    }

    private func handleError(_ message: String) {
        print(message)
        stopLoadingIndicator()
    }
    
    private func handleImageData(_ jsonData: Data) {
        do {
            guard let jsonResponse = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                  let images = jsonResponse["images"] as? [[String: Any]],
                  let firstImage = images.first,
                  let imageId = firstImage["id"] as? String,
                  let tagsArray = firstImage["tags"] as? [String] else {
                handleError("Failed to parse JSON response.")
                return
            }
            
            updateUIWithTags(tagsArray)
            loadImage(with: imageId, tags: tagsArray)
        } catch {
            handleError("JSON parsing error: \(error.localizedDescription)")
        }
    }
    
    private func loadImage(with imageId: String, tags: [String]?) {
        var urlComponents = URLComponents(string: "https://nekos.moe/thumbnail/\(imageId)")
        if let tags = tags {
            urlComponents?.queryItems = [URLQueryItem(name: "tags", value: tags.joined(separator: ","))]
        }
        
        guard let url = urlComponents?.url else {
            handleError("Invalid URL")
            return
        }
        
        let imageRequest = URLRequest(url: url)
        
        let imageTask = URLSession.shared.dataTask(with: imageRequest) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.handleError("Image loading error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    self.handleError("Failed to load image data.")
                    return
                }
                
                self.handleImageLoadingCompletion(image, tags: tags)
            }
        }
        
        imageTask.resume()
    }
    
    private func handleImageLoadingCompletion(_ image: UIImage, tags: [String]?) {
        self.imageView.image = image
        self.addToHistory(image: image)
        self.animateImageChange(with: image)
        if let tags = tags {
            self.addImageToHistory(image: image, tags: tags)
        }
        self.incrementCounter()
        self.tagsLabel.isHidden = false
        self.setTagsLines0()
        self.stopLoadingIndicator()
    }
}
