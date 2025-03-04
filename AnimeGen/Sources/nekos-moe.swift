//
//  nekosmoe.swift
//  AnimeGen
//
//  Created by Francesco on 04/03/25.
//

import UIKit

extension ViewController {
    func fetchImageFromNekosMoe() {
        guard let url = URL(string: "https://nekos.moe/api/v1/random/image?nsfw=false") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.custom.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching image from nekos.moe: \(error)")
                self.showErrorAlert(message: "Failed to load image from nekos.moe")
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let data = data else {
                print("No data received from nekos.moe")
                self.showErrorAlert(message: "No data received from nekos.moe")
                self.activityIndicator.stopAnimating()
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let images = json["images"] as? [[String: Any]],
                   let firstImage = images.first,
                   let imageUrlString = firstImage["id"] as? String,
                   let imageUrl = URL(string: "https://nekos.moe/thumbnail/" + imageUrlString) {
                    DispatchQueue.main.async {
                        self.loadImage(from: imageUrl)
                    }
                } else {
                    print("Error parsing nekos.moe JSON")
                    self.showErrorAlert(message: "Error parsing nekos.moe JSON")
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error decoding nekos.moe JSON: \(error)")
                self.showErrorAlert(message: "Error decoding nekos.moe JSON")
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
}
