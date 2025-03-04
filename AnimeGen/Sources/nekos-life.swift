//
//  nekos-life.swift
//  AnimeGen
//
//  Created by Francesco on 04/03/25.
//

import UIKit

extension ViewController {
    func fetchImageFromNekosLife() {
        let baseURL = URL(string: "https://nekos.life/api/v2/")!
        
        let categories = ["/img/tickle", "/img/slap", "/img/poke", "/img/pat", "/img/neko", "/img/meow", "/img/lizard", "/img/kiss", "/img/hug", "/img/fox_girl", "/img/feed", "/img/cuddle", "/img/ngif", "/img/kemonomimi", "/img/holo", "/img/smug", "/img/baka", "/img/woof", "/img/wallpaper", "/img/goose", "/img/gecg", "/img/avatar", "/img/waifu"]
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
                print("Error fetching image from nekos-life: \(error)")
                self.showErrorAlert(message: "Failed to load image from nekos-life")
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let data = data else {
                print("No data received from nekos-life")
                self.showErrorAlert(message: "No data received from nekos-life")
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
                    print("Error parsing nekos-life JSON")
                    self.showErrorAlert(message: "Error parsing nekos-life JSON")
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error decoding nekos-life JSON: \(error)")
                self.showErrorAlert(message: "Error decoding nekos-life JSON")
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
}
