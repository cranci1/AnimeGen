//
//  waifu-pics.swift
//  AnimeGen
//
//  Created by Francesco on 04/03/25.
//

import UIKit

extension ViewController {
    func fetchImageFromWaifuPics() {
        let baseURL = URL(string: "https://api.waifu.pics/sfw/")!
        
        let categories = ["waifu", "neko", "shinobu", "cuddle", "hug", "kiss", "lick", "pat", "bonk", "blush", "smile", "nom", "bite", "glomp", "slap", "kick", "happy", "poke", "dance"]
        let randomIndex = Int(arc4random_uniform(UInt32(categories.count)))
        let randomCategory = categories[randomIndex]
        
        guard let url = URL(string: "\(baseURL)\(randomCategory)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.custom.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching waifu.pics image: \(error)")
                self.showErrorAlert(message: "Failed to load image from waifu.pics")
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let data = data else {
                print("No data received from waifu.pics")
                self.showErrorAlert(message: "No data received from waifu.pics")
                self.activityIndicator.stopAnimating()
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                   let fileURLString = json["url"] as? String,
                   let fileURL = URL(string: fileURLString) {
                    DispatchQueue.main.async {
                        self.loadImage(from: fileURL)
                    }
                } else {
                    print("Error parsing waifu.pics JSON")
                    self.showErrorAlert(message: "Error parsing waifu.pics JSON")
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error decoding waifu.pics JSON: \(error)")
                self.showErrorAlert(message: "Error decoding waifu.pics JSON")
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
}
