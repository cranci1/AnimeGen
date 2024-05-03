//
//  nekosbot.swift
//  AnimeGen
//
//  Created by cranci on 25/04/24.
//

import UIKit

extension ViewController {
    
    func loadImageFromNekoBot() {
        startLoadingIndicator()

        let categories: [String]
        let endpointPrefix: String

        if UserDefaults.standard.bool(forKey: "enableExplictiCont") {
            categories = ["hentai", "hkitsune", "hanal", "hthigh", "hboobs", "yaoi"]
            endpointPrefix = "https://nekobot.xyz/api/image?type="
        } else {
            categories = ["neko", "coffee", "food", "kemonomimi"]
            endpointPrefix = "https://nekobot.xyz/api/image?type="
        }

        let randomCategory = categories.randomElement() ?? "neko"

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

                if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let imageUrlString = jsonResponse["message"] as? String, let imageUrl = URL(string: imageUrlString) {

                    if let imageData = try? Data(contentsOf: imageUrl) {
                        if imageUrlString.lowercased().hasSuffix(".gif") {
                            if let animatedImage = UIImage.animatedImage(with: UIImage.gifData(data: imageData) ?? [], duration: 1.0) {
                                self.imageView.image = animatedImage
                                self.animateImageChange(with: animatedImage)
                                self.addToHistory(image: animatedImage)
                            } else {
                                print("Failed to create animated image from GIF data.")
                            }
                        } else {
                            if let newImage = UIImage(data: imageData) {
                                self.imageView.image = newImage
                                self.animateImageChange(with: newImage)
                                self.addToHistory(image: newImage)
                            } else {
                                print("Failed to load image data.")
                            }
                        }
                        self.currentImageURL = imageUrlString
                        self.tagsLabel.isHidden = false
                        self.updateUIWithTags([randomCategory])
                        self.stopLoadingIndicator()
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

        task.resume()
    }
    
}
