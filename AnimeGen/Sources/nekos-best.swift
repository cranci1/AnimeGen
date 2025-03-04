//
//  nekos-best.swift
//  AnimeGen
//
//  Created by Francesco on 04/03/25.
//

import UIKit

extension ViewController {
    func fetchImageFromNekosBest() {
        let baseURL = URL(string: "https://nekos.best/api/v2/")!
        
        let categories = ["neko", "waifu", "husbando", "kitsune", "lurk", "shoot", "sleep", "shrug", "stare", "wave", "poke", "smile", "peck", "wink", "blush", "smug", "tickle", "yeet", "think", "highfive", "feed", "bite", "bored", "nom", "yawn", "facepalm", "cuddle", "kick", "happy", "hug", "baka", "pat", "nod", "nope", "kiss", "dance", "punch", "handshake", "slap", "cry", "pout", "handhold", "thumbsup", "laugh"]
        let randomIndex = Int(arc4random_uniform(UInt32(categories.count)))
        let randomCategory = categories[randomIndex]
        
        guard let url = URL(string: "\(baseURL)\(randomCategory)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.custom.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching image from nekos-best: \(error)")
                self.showErrorAlert(message: "Failed to load image from nekos-best")
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let data = data else {
                print("No data received from nekos-best")
                self.showErrorAlert(message: "No data received from nekos-best")
                self.activityIndicator.stopAnimating()
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let images = json["results"] as? [[String: Any]],
                   let firstImage = images.first,
                   let imageUrlString = firstImage["url"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    DispatchQueue.main.async {
                        self.loadImage(from: imageUrl)
                    }
                } else {
                    print("Error parsing nekos-best JSON")
                    self.showErrorAlert(message: "Error parsing nekos-best JSON")
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error decoding nekos-best JSON: \(error)")
                self.showErrorAlert(message: "Error decoding nekos-best JSON")
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
}
