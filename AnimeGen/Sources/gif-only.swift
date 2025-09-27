//
//  gif-only.swift
//  AnimeGen
//
//  Created by Mousica on 27/09/25.
//

import UIKit

extension ViewController {
    func fetchImageFromGifOnly() {
        // Random categories
        let gifCategories = ["hug", "kiss", "pat", "slap", "dance", "happy", "cuddle", "tickle", "poke", "smile", "wink", "yawn"]
        let randomGifCategory = gifCategories.randomElement() ?? "hug"
        
        let purrBotGifCategories = ["angry", "bite", "blush", "comfy", "cry", "cuddle", "dance", "fluff", "hug", "kiss", "lay", "lick", "pat", "poke", "pout", "slap", "smile", "tail", "tickle"]
        let randomPurrBotCategory = purrBotGifCategories.randomElement() ?? "hug"
        
        // API list
        let gifOnlyAPIs: [String: String] = [
            "nekos.api.gif": "https://api.nekosapi.com/v4/images/random?is_gif=true",
            "nekos.best.gif": "https://nekos.best/api/v2/\(randomGifCategory)",
            "nekos.life.gif": "https://nekos.life/api/v2/img/ngif",
            "purr.category.gif": "https://api.purrbot.site/v2/img/sfw/\(randomPurrBotCategory)/gif"
        ]
        
        // Pick random API
        guard let (selectedAPI, apiURL) = gifOnlyAPIs.randomElement(),
              let url = URL(string: apiURL) else {
            print("Invalid API URL")
            return
        }
        
        let task = URLSession.custom.dataTask(with: url) { [weak self] (data, _, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.handleApiError(selectedAPI, message: "Failed to load gif: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                self.handleApiError(selectedAPI, message: "No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    var gifURL: URL?
                    
                    switch selectedAPI {
                    case "purr.category.gif":
                        gifURL = (json["link"] as? String).flatMap(URL.init)
                    case "nekos.life.gif":
                        gifURL = (json["url"] as? String).flatMap(URL.init)
                    case "nekos.best.gif":
                        if let result = (json["results"] as? [[String: Any]])?.first,
                           let urlStr = result["url"] as? String {
                            gifURL = URL(string: urlStr)
                        }
                    case "nekos.api.gif":
                        if let item = (json["items"] as? [[String: Any]])?.first,
                           let urlStr = item["image_url"] as? String {
                            gifURL = URL(string: urlStr)
                        }
                    default:
                        break
                    }
                    
                    if let gifURL = gifURL {
                        DispatchQueue.main.async { self.loadImage(from: gifURL) }
                    } else {
                        self.handleApiError(selectedAPI, message: "Error parsing JSON")
                    }
                } else {
                    self.handleApiError(selectedAPI, message: "Invalid JSON format")
                }
            } catch {
                self.handleApiError(selectedAPI, message: "Decoding error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    private func handleApiError(_ api: String, message: String) {
        print("Error with \(api): \(message)")
        DispatchQueue.main.async {
            self.showErrorAlert(message: message)
            self.activityIndicator.stopAnimating()
        }
    }
}