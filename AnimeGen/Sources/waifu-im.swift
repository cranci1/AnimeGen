//
//  waifu-im.swift
//  AnimeGen
//
//  Created by Francesco on 23/02/25.
//

import UIKit

extension ViewController {
    func fetchImageFromWaifuIm() {
        let url = URL(string: "https://api.waifu.im/search?is_nsfw=true")!
        
        let task = URLSession.custom.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching waifu.im image: \(error)")
                self.showErrorAlert(message: "Failed to load image from waifu.im")
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let data = data else {
                print("No data received from waifu.im")
                self.showErrorAlert(message: "No data received from waifu.im")
                self.activityIndicator.stopAnimating()
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let images = json["images"] as? [[String: Any]],
                   let firstImage = images.first,
                   let imageUrlString = firstImage["url"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    DispatchQueue.main.async {
                        self.loadImage(from: imageUrl)
                    }
                } else {
                    print("Error parsing waifu.im JSON")
                    self.showErrorAlert(message: "Error parsing waifu.im JSON")
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error decoding waifu.im JSON: \(error)")
                self.showErrorAlert(message: "Error decoding waifu.im JSON")
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
}
