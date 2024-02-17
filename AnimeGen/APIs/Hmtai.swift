//
//  Hmtai.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

extension ViewController {
    
    func loadImagesFromHmtai() {
        startLoadingIndicator()

        let categories3 = ["wave","wink","tea","bonk","punch","poke","bully","pat","kiss","kick","blush","feed","smug","hug","cuddle","cry","cringe","slap","five","glomp","happy","hold","nom","smile","throw","lick","bite","dance","boop","sleep","like","kill","tickle","nosebleed","threaten","depression","wolf_arts","jahy_arts","neko_arts","coffee_arts","wallpaper","mobileWallpaper"]
        let randomCategory3 = categories3.randomElement() ?? "pat"

        let apiEndpoint = "https://hmtai.hatsunia.cfd/sfw/\(randomCategory3)"

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
                            
                            if let animatedImage = UIImage.animatedImage(with: UIImage.gifData(data: imageData) ?? [], duration: 2.0) {
                                self.imageView.image = animatedImage
                                self.animateImageChange(with: animatedImage)
                            } else {
                                print("Failed to create animated image from GIF data.")
                            }
                        } else {

                            if let newImage = UIImage(data: imageData) {
                                self.imageView.image = newImage
                                self.animateImageChange(with: newImage)
                            } else {
                                print("Failed to load image data.")
                            }
                        }

                        let category3 = randomCategory3
                        
                        self.currentImageURL = imageUrlString

                        self.updateUIWithTags([category3])

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

