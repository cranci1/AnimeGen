//
//  kyoko.swift
//  AnimeGen
//
//  Created by cranci on 15/03/24.
//

import UIKit

extension ViewController {
    
    func loadImageFromKyoko() {
        startLoadingIndicator()

        let categories: [String]
        let endpointPrefix: String

        if UserDefaults.standard.bool(forKey: "enableExplictiCont") {
            categories = ["waifu", "neko", "trap", "blowjob"]
            endpointPrefix = "https://waifu.rei.my.id/nsfw/"
        } else {
            categories = ["waifu", "neko", "shinobu", "megumin", "bully", "cuddle", "cry", "hug", "awoo", "kiss", "lick", "pat", "smug", "bonk", "blush", "smile", "nom", "bite", "glomp", "slap", "kick", "happy", "poke", "dance"]
            endpointPrefix = "https://waifu.rei.my.id/sfw/"
        }

        let randomCategory = categories.randomElement() ?? "waifu"

        let apiEndpoint = "\(endpointPrefix)\(randomCategory)"

        guard let url = URL(string: apiEndpoint) else {
            showAlert(withTitle: "Invalid URL", message: "Please wait, the api may be down.", viewController: self)
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(withTitle: "Error!", message: "\(error)", viewController: self)
                    print("Error: \(error)")
                    self.stopLoadingIndicator()
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    self.showAlert(withTitle: "Invalid HTTP response", message: "Please wait, the api may be down.", viewController: self)
                    print("Invalid HTTP response")
                    self.stopLoadingIndicator()
                    return
                }

                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let requestResult = jsonResponse["RequestResult"] as? [String: Any],
                           let imageUrlString = requestResult["url"] as? String,
                           let imageUrl = URL(string: imageUrlString) {
                            
                            self.loadImage(from: imageUrl, withCategory: randomCategory)
                            
                        } else {
                            self.showAlert(withTitle: "Error!", message: "Failed to parse JSON response or missing necessary data.", viewController: self)
                            print("Failed to parse JSON response or missing necessary data.")
                            self.stopLoadingIndicator()
                        }
                    } catch {
                        self.showAlert(withTitle: "Error!", message: "Failed to parse JSON response.", viewController: self)
                        print("Failed to parse JSON response:", error)
                        self.stopLoadingIndicator()
                    }
                } else {
                    self.showAlert(withTitle: "Error!", message: "No data received from server.", viewController: self)
                    print("No data received from server.")
                    self.stopLoadingIndicator()
                }
            }
        }

        task.resume()
    }
    
    func loadImage(from url: URL, withCategory category: String) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(withTitle: "Error!", message: "\(error)", viewController: self)
                print("Error loading image:", error)
                self.stopLoadingIndicator()
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.showAlert(withTitle: "Invalid HTTP response", message: "Failed to load image.", viewController: self)
                print("Invalid HTTP response")
                self.stopLoadingIndicator()
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        if url.absoluteString.lowercased().hasSuffix(".gif") {
                            if let animatedImage = UIImage.animatedImage(with: UIImage.gifData(data: data) ?? [], duration: 1.0) {
                                self.imageView.image = animatedImage
                                self.addToHistory(image: animatedImage)
                                self.animateImageChange(with: animatedImage)
                            } else {
                                self.showAlert(withTitle: "Error!", message: "Failed to create animated image from GIF data.", viewController: self)
                                print("Failed to create animated image from GIF data.")
                            }
                        } else {
                            self.imageView.image = image
                            self.addToHistory(image: image)
                            self.animateImageChange(with: image)
                        }
                        
                        self.tagsLabel.isHidden = false
                        self.updateUIWithTags([category])
                        self.currentImageURL = url.absoluteString
                        self.stopLoadingIndicator()
                        self.incrementCounter()
                    } else {
                        self.showAlert(withTitle: "Error!", message: "Failed to load image data.", viewController: self)
                        print("Failed to load image data.")
                        self.stopLoadingIndicator()
                    }
                }
            } else {
                self.showAlert(withTitle: "Error!", message: "No image data received from server.", viewController: self)
                print("No image data received from server.")
                self.stopLoadingIndicator()
            }
        }.resume()
    }
}
