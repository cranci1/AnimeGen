//
//  purr.swift
//  AnimeGen
//
//  Created by Francesco on 04/03/25.
//

import UIKit

extension ViewController {
    func fetchImageFromPurr() {
        let baseURL = URL(string: "https://purrbot.site/api/img/sfw/")!
        
        let categories = ["angry/gif", "bite/gif", "blush/gif", "comfy/gif", "cry/gif", "cuddle/gif", "dance/gif", "eevee/gif", "fluff/gif", "holo/gif", "hug/gif", "kiss/gif", "lay/gif", "lick/gif", "neko/gif", "pat/gif", "poke/gif", "pout/gif", "slap/gif", "smile/gif", "tail/gif", "tickle/gif", "background/img", "eevee/img", "holo/img", "icon/img", "kitsune/img", "neko/img", "okami/img", "senko/img", "shiro/img"]
        let randomIndex = Int(arc4random_uniform(UInt32(categories.count)))
        let randomCategory = categories[randomIndex]
        
        guard let url = URL(string: "\(baseURL)\(randomCategory)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.custom.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching purr image: \(error)")
                self.showErrorAlert(message: "Failed to load image from purr")
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let data = data else {
                print("No data received from purr")
                self.showErrorAlert(message: "No data received from purr")
                self.activityIndicator.stopAnimating()
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                   let fileURLString = json["link"] as? String,
                   let fileURL = URL(string: fileURLString) {
                    DispatchQueue.main.async {
                        self.loadImage(from: fileURL)
                    }
                } else {
                    print("Error parsing purr JSON")
                    self.showErrorAlert(message: "Error parsing purr JSON")
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error decoding purr JSON: \(error)")
                self.showErrorAlert(message: "Error decoding purr JSON")
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
}
