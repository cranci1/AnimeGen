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

        let categoriesSFW: [String] = ["neko", "coffee", "food", "kemonomimi",]
        let categoriesNSFW: [String] = ["hentai", "hkitsune", "hanal", "hthigh", "hboobs", "yaoi"]

        let isExplicitContentEnabled = UserDefaults.standard.bool(forKey: "enableExplictiCont")
        let randomCategory = isExplicitContentEnabled ? categoriesNSFW.randomElement() ?? "hentai" : categoriesSFW.randomElement() ?? "hass"

        let apiEndpoint = "https://nekobot.xyz/api/image?type=\(randomCategory)"

        guard let url = URL(string: apiEndpoint) else {
            if self.alert {
                self.showAlert(withTitle: "Invalid URL", message: "Please wait, the API may be down.", viewController: self)
            }
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    if self.alert {
                        self.showAlert(withTitle: "Error!", message: "\(error)", viewController: self)
                    }
                    print("Error: \(error)")
                    self.stopLoadingIndicator()
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    if self.alert {
                        self.showAlert(withTitle: "Invalid HTTP response", message: "Please wait, the API may be down.", viewController: self)
                    }
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
                                if self.alert {
                                    self.showAlert(withTitle: "Error!", message: "Failed to create animated image from GIF data.", viewController: self)
                                }
                            }
                        } else {
                            if let newImage = UIImage(data: imageData) {
                                self.imageView.image = newImage
                                self.addToHistory(image: newImage)
                                self.animateImageChange(with: newImage)
                            } else {
                                print("Failed to load image data.")
                                if self.alert {
                                    self.showAlert(withTitle: "Error!", message: "Failed to load image data.", viewController: self)
                                }
                            }
                        }
                        self.currentImageURL = imageUrlString
                        self.tagsLabel.isHidden = false
                        self.updateUIWithTags([randomCategory])
                        self.stopLoadingIndicator()
                        self.incrementCounter()
                    } else {
                        print("Failed to load image data.")
                        if self.alert {
                            self.showAlert(withTitle: "Error!", message: "Failed to load image data.", viewController: self)
                        }
                        self.stopLoadingIndicator()
                    }
                } else {
                    if self.alert {
                        self.showAlert(withTitle: "Error!", message: "Failed to parse JSON response or missing data.", viewController: self)
                    }
                    print("Failed to parse JSON response or missing necessary data.")
                    self.stopLoadingIndicator()
                }
            }
        }

        task.resume()
    }
    
}
