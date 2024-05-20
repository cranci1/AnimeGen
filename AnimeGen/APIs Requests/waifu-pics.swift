//
//  waifu-pics.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

extension ViewController {
    
    func loadImageFromWaifuPics() {
        startLoadingIndicator()

        let categories: [String]
        let endpointPrefix: String

        if UserDefaults.standard.bool(forKey: "enableExplicitContent") {
            categories = ["waifu", "neko", "trap", "blowjob"]
            endpointPrefix = "https://api.waifu.pics/nsfw/"
        } else {
            categories = ["waifu", "neko", "shinobu", "cuddle", "hug", "kiss", "lick", "pat", "bonk", "blush", "smile", "nom", "bite", "glomp", "slap", "kick", "happy", "poke", "dance"]
            endpointPrefix = "https://api.waifu.pics/sfw/"
        }

        let randomCategory = categories.randomElement() ?? "waifu"
        let apiEndpoint = "\(endpointPrefix)\(randomCategory)"

        guard let url = URL(string: apiEndpoint) else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        let startTime = Date()
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let error = error {
                    self.handleError("Error: \(error)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let data = data,
                      let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let imageUrlString = jsonResponse["url"] as? String else {
                    self.handleError("Invalid HTTP response or data")
                    return
                }

                self.loadImage(with: imageUrlString, tags: [randomCategory], startTime: startTime)
            }
        }.resume()
    }
    
    private var imageCache: ImageCache {
        return ImageCache()
    }

    private func loadImage(with imageUrlString: String, tags: [String], startTime: Date) {
        guard let imageUrl = URL(string: imageUrlString) else {
            handleError("Invalid image URL")
            return
        }

        if let cachedImage = imageCache.image(for: imageUrl as NSURL) {
            handleImageLoadingCompletion(with: cachedImage, tags: tags, imageUrlString: imageUrlString, startTime: startTime)
            return
        }

        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: imageUrl) {
                DispatchQueue.main.async {
                    if imageUrlString.lowercased().hasSuffix(".gif") {
                        if let animatedImage = UIImage.animatedImage(with: UIImage.gifData(data: imageData) ?? [], duration: 1.0) {
                            self.imageCache.insertImage(animatedImage, for: imageUrl as NSURL)
                            self.handleImageLoadingCompletion(with: animatedImage, tags: tags, imageUrlString: imageUrlString, startTime: startTime)
                        } else {
                            self.handleError("Failed to create animated image from GIF data.")
                        }
                    } else {
                        if let newImage = UIImage(data: imageData) {
                            self.imageCache.insertImage(newImage, for: imageUrl as NSURL)
                            self.handleImageLoadingCompletion(with: newImage, tags: tags, imageUrlString: imageUrlString, startTime: startTime)
                        } else {
                            self.handleError("Failed to load image data.")
                        }
                    }
                }
            } else {
                self.handleError("Failed to load image data.")
            }
        }
    }
    
    private func handleError(_ message: String) {
        print(message)
        DispatchQueue.main.async {
            self.stopLoadingIndicator()
        }
    }

    private func handleImageLoadingCompletion(with newImage: UIImage, tags: [String], imageUrlString: String, startTime: Date) {
        addImageToHistory(image: newImage, tags: tags)
        currentImageURL = imageUrlString
        updateUIWithTags(tags)
        addToHistory(image: newImage)
        tagsLabel.isHidden = false
        imageView.image = newImage
        animateImageChange(with: newImage)
        stopLoadingIndicator()
        incrementCounter()
        
        let executionTime = Date().timeIntervalSince(startTime)
        print("Execution time: \(executionTime) seconds")
    }
}
