//
//  n-sfw.swift
//  AnimeGen
//
//  Created by cranci on 15/05/24.
//

import UIKit

extension ViewController {
    
    func loadImageFromNSFW() {
        startLoadingIndicator()

        let categories: [String]
        let endpointPrefix: String

        if UserDefaults.standard.bool(forKey: "enableExplicitContent") {
            categories = ["anal","ass", "blowjob", "breeding", "buttplug", "cages", "ecchi", "feet", "fo", "furry", "gif", "hentai", "legs", "masturbation", "milf", "muscle", "neko", "paizuri", "petgirls", "pierced", "selfie", "smothering", "socks", "trap", "vagina", "yaoi", "yuri"]
            endpointPrefix = "https://api.n-sfw.com/nsfw/"
        } else {
            categories = ["bunny-girl", "charlotte", "date-a-live", "death-note", "demon-slayer", "haikyu", "hxh", "kakegurui", "konosuba", "komi", "memes", "naruto", "noragami", "one-piece", "rag", "sakurasou", "sao", "sds", "spy-x-family", "takagi-san", "toradora", "your-name"]
            endpointPrefix = "https://api.n-sfw.com/sfw/"
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

                if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let imageUrlString = jsonResponse["url"] as? String, let imageUrl = URL(string: imageUrlString) {

                    if let imageData = try? Data(contentsOf: imageUrl) {
                        if imageUrlString.lowercased().hasSuffix(".gif") {
                            if let animatedImage = UIImage.animatedImage(with: UIImage.gifData(data: imageData) ?? [], duration: 1.0) {
                                self.imageView.image = animatedImage
                                self.addImageToHistory(image: animatedImage, tags: [randomCategory])
                                self.animateImageChange(with: animatedImage)
                                self.addToHistory(image: animatedImage)
                            } else {
                                print("Failed to create animated image from GIF data.")
                            }
                        } else {
                            if let newImage = UIImage(data: imageData) {
                                self.imageView.image = newImage
                                self.addImageToHistory(image: newImage, tags: [randomCategory])
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
                        self.incrementCounter()
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
