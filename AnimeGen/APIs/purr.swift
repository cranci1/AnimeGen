//
//  purr.swift
//  AnimeGen
//
//  Created by cranci on 16/03/24.
//

import Foundation
import UIKit

extension ViewController {
    
    func loadImageFromPurr() {
        startLoadingIndicator()

        var categories: [String]
        var endpointPrefix: String

        if UserDefaults.standard.bool(forKey: "enableExplictiCont") {
            categories = ["anal/gif", "blowjob/gif", "cum/gif", "fuck/gif", "neko/gif", "pussylick/gif", "solo/gif", "solo_male/gif", "threesome_fff/gif", "threesome_ffm/gif", "threesome_mmf/gif", "yuri/gif", "neko/img"]
            endpointPrefix = "https://purrbot.site/api/img/nsfw/"
        } else {
            categories = ["angry/gif", "bite/gif", "blush/gif", "comfy/gif", "cry/gif", "cuddle/gif", "dance/gif", "eevee/gif", "fluff/gif", "holo/gif", "hug/gif", "kiss/gif", "lay/gif", "lick/gif", "neko/gif", "pat/gif", "poke/gif", "pout/gif", "slap/gif", "smile/gif", "tail/gif", "tickle/gif", "background/img", "eevee/img", "holo/img", "icon/img", "kitsune/img", "neko/img", "okami/img", "senko/img", "shiro/img"]
            endpointPrefix = "https://purrbot.site/api/img/sfw/"
        }

        let randomCategory = categories.randomElement() ?? "neko/img"

        var tag = randomCategory.components(separatedBy: "/").first ?? ""

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

                if let data = data {
                    do {
                        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let imageUrlString = jsonResponse["link"] as? String,
                           let imageUrl = URL(string: imageUrlString) {

                            if let imageData = try? Data(contentsOf: imageUrl) {
                                if imageUrlString.lowercased().hasSuffix(".gif") {
                                    if let animatedImage = UIImage.animatedImage(with: UIImage.gifData(data: imageData) ?? [], duration: 1.0) {
                                        self.imageView.image = animatedImage
                                        self.addToHistory(image: animatedImage)
                                        self.animateImageChange(with: animatedImage)
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
                                
                                tag = tag.components(separatedBy: "/").first ?? ""
                                self.updateUIWithTags([tag])

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
                } else {
                    print("No data received from server.")
                    self.stopLoadingIndicator()
                }
            }
        }

        task.resume()
    }
    
}
