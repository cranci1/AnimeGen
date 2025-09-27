//
//  image-only.swift
//  AnimeGen
//
//  Created by Mousica on 27/09/25.
//

import UIKit

extension ViewController {
    func fetchImageFromImageOnly() {
        // Random categories
        let imageCategories = ["neko", "waifu", "kitsune", "husbando"]
        let randomImageCategory = imageCategories.randomElement() ?? "neko"
        
        // PurrBot  image categories
        let purrBotCategories: [String: [String]] = [
            "neko": ["img"],
            "eevee": ["img"],
            "background": ["img"],
            "holo": ["img"],
            "icon": ["img"],
            "kitsune": ["img"],
            "okami": ["img"],
            "senko": ["img"],
            "shiro": ["img"]
        ]
        
        let randomPurrCategory = purrBotCategories.keys.randomElement() ?? "neko"
        
        // API list
        let imageOnlyAPIs: [String: String] = [
            "nekobot": "https://nekobot.xyz/api/image?type=neko",
            "nekosapi": "https://api.nekosapi.com/v4/images/random?rating=safe",
            "nekos.best": "https://nekos.best/api/v2/\(randomImageCategory)",
            "nekos.life": "https://nekos.life/api/v2/img/neko",
            "nekos.moe": "https://nekos.moe/api/v1/random/image?nsfw=false",
            "pic.re": "https://pic.re/images.json?nin=nsfw",
            "purrbot": "https://api.purrbot.site/v2/img/sfw/\(randomPurrCategory)/img",
            "waifu.im": "https://api.waifu.im/search?is_nsfw=false",
            "waifu.pics": "https://api.waifu.pics/sfw/waifu"
        ]
        
        guard let (selectedAPI, apiURL) = imageOnlyAPIs.randomElement(),
              let url = URL(string: apiURL) else {
            print("Invalid API URL")
            return
        }
        
        let task = URLSession.custom.dataTask(with: url) { [weak self] (data, _, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.handleApiError(selectedAPI, message: "Failed to load image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                self.handleApiError(selectedAPI, message: "No data received")
                return
            }
            
            do {
                var imageURL: URL?
                
                if selectedAPI == "nekosapi",
                   let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],
                   let urlStr = jsonArray.first?["url"] as? String {
                    imageURL = URL(string: urlStr)
                } else if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    switch selectedAPI {
                    case "waifu.im":
                        if let first = (json["images"] as? [[String: Any]])?.first,
                           let urlStr = first["url"] as? String {
                            imageURL = URL(string: urlStr)
                        }
                    case "waifu.pics":
                        imageURL = (json["url"] as? String).flatMap(URL.init)
                    case "nekos.best":
                        if let first = (json["results"] as? [[String: Any]])?.first,
                           let urlStr = first["url"] as? String {
                            imageURL = URL(string: urlStr)
                        }
                    case "nekos.life":
                        imageURL = (json["url"] as? String).flatMap(URL.init)
                    case "nekos.moe":
                        if let first = (json["images"] as? [[String: Any]])?.first,
                           let id = first["id"] as? String {
                            imageURL = URL(string: "https://nekos.moe/image/\(id)")
                        }
                    case "nekobot":
                        imageURL = (json["message"] as? String).flatMap(URL.init)
                    case "pic.re":
                        imageURL = (json["file_url"] as? String).flatMap(URL.init)
                    case "purrbot":
                        imageURL = (json["link"] as? String).flatMap(URL.init)
                    default:
                        break
                    }
                }
                
                if let imageURL = imageURL {
                    DispatchQueue.main.async { self.loadImage(from: imageURL) }
                } else {
                    self.handleApiError(selectedAPI, message: "Error parsing JSON")
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