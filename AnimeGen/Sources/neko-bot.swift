//
//  neko-bot.swift
//  AnimeGen
//
//  Created by Francesco on 04/03/25.
//

import UIKit

extension ViewController {
    func fetchImageFromNekoBot() {
        let baseURL = URL(string: "https://nekobot.xyz/api/image?type=")!
        
        let categories = ["neko", "coffee", "food", "kemonomimi"]
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
                print("Error fetching image from nekobot: \(error)")
                self.showErrorAlert(message: "Failed to load image from nekobot")
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let data = data else {
                print("No data received from nekobot")
                self.showErrorAlert(message: "No data received from nekobot")
                self.activityIndicator.stopAnimating()
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                   let fileURLString = json["message"] as? String,
                   let fileURL = URL(string: fileURLString) {
                    DispatchQueue.main.async {
                        self.loadImage(from: fileURL)
                    }
                } else {
                    print("Error parsing nekobot JSON")
                    self.showErrorAlert(message: "Error parsing nekobot JSON")
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error decoding nekobot JSON: \(error)")
                self.showErrorAlert(message: "Error decoding nekobot JSON")
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
}
