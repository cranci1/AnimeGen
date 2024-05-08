//
//  waifu-im.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

extension ViewController {
    
    func loadImageFromWaifuIm() {
        startLoadingIndicator()

        DispatchQueue.global().async {
            let isNSFW = UserDefaults.standard.bool(forKey: "enableExplictiCont")
            let apiEndpoint = "https://api.waifu.im/search"
            
            var components = URLComponents(string: apiEndpoint)
            components?.queryItems = [
                URLQueryItem(name: "is_nsfw", value: isNSFW ? "true" : "false")
            ]
            
            guard let url = components?.url else {
                print("Invalid URL")
                self.stopLoadingIndicator()
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error: \(error)")
                        self.stopLoadingIndicator()
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        print("Invalid HTTP response")
                        self.stopLoadingIndicator()
                        return
                    }
                    
                    do {
                        if let jsonData = data,
                           let jsonResponse = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                           let images = jsonResponse["images"] as? [[String: Any]],
                           let firstImage = images.first,
                           let imageUrlString = firstImage["url"] as? String,
                           let imageUrl = URL(string: imageUrlString),
                           let tagsArray = firstImage["tags"] as? [[String: Any]] {
                            
                            self.currentImageURL = imageUrlString
                            
                            let tags = tagsArray.compactMap { $0["name"] as? String }
                            
                            if let data = try? Data(contentsOf: imageUrl), let newImage = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.imageView.image = newImage
                                    self.addToHistory(image: newImage)
                                    self.animateImageChange(with: newImage)
                                    self.tagsLabel.isHidden = false
                                    self.addImageToHistory(image: newImage, tags: tags)
                                    self.updateUIWithTags(tags)
                                    self.stopLoadingIndicator()
                                    self.incrementCounter()
                                }
                            } else {
                                print("Failed to load image data.")
                                self.stopLoadingIndicator()
                            }
                        } else {
                            print("Failed to parse JSON response or missing necessary data.")
                            self.stopLoadingIndicator()
                        }
                    }
                }
            }.resume()
        }
    }
    
}
