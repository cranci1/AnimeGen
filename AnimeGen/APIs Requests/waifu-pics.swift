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

        if UserDefaults.standard.bool(forKey: "enableExplictiCont") {
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

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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

                if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let imageUrlString = jsonResponse["url"] as? String {
                    self.loadImage(with: imageUrlString, tags: [randomCategory])
                } else {
                    print("Failed to parse JSON response or missing necessary data.")
                    self.stopLoadingIndicator()
                }
            }
        }

        task.resume()
    }
    
    private func loadImage(with imageUrlString: String, tags: [String]) {
        guard let imageUrl = URL(string: imageUrlString) else {
            print("Invalid image URL")
            stopLoadingIndicator()
            return
        }

        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: imageUrl) {
                DispatchQueue.main.async {
                    if imageUrlString.lowercased().hasSuffix(".gif") {
                        if let animatedImage = UIImage.animatedImage(with: UIImage.gifData(data: imageData) ?? [], duration: 1.0) {
                            self.handleImageLoadingCompletion(with: animatedImage, tags: tags, imageUrlString: imageUrlString)
                        } else {
                            print("Failed to create animated image from GIF data.")
                            self.stopLoadingIndicator()
                        }
                    } else {
                        if let newImage = UIImage(data: imageData) {
                            self.handleImageLoadingCompletion(with: newImage, tags: tags, imageUrlString: imageUrlString)
                        } else {
                            print("Failed to load image data.")
                            self.stopLoadingIndicator()
                        }
                    }
                }
            } else {
                print("Failed to load image data.")
                self.stopLoadingIndicator()
            }
        }
    }
    
    private func handleImageLoadingCompletion(with newImage: UIImage, tags: [String], imageUrlString: String) {
        addImageToHistory(image: newImage, tags: tags)
        currentImageURL = imageUrlString
        updateUIWithTags(tags)
        addToHistory(image: newImage)
        tagsLabel.isHidden = false
        imageView.image = newImage
        animateImageChange(with: newImage)
        stopLoadingIndicator()
        incrementCounter()
    }
}
