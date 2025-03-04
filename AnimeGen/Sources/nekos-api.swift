//
//  nekos-api.swift
//  AnimeGen
//
//  Created by Francesco on 04/03/25.
//

import UIKit

extension ViewController {
    func fetchImageFromNekosApi() {
        guard let url = URL(string: "https://api.nekosapi.com/v4/images/random?limit=1&rating=safe") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.custom.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching image from nekos-api: \(error)")
                self.showErrorAlert(message: "Failed to load image from nekos-api")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            guard let data = data else {
                print("No data received from nekos-api")
                self.showErrorAlert(message: "No data received from nekos-api")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                   let firstImage = jsonArray.first,
                   let fileURLString = firstImage["url"] as? String,
                   let fileURL = URL(string: fileURLString) {
                    DispatchQueue.main.async {
                        self.loadImage(from: fileURL)
                    }
                } else {
                    print("Error parsing nekos-api JSON")
                    self.showErrorAlert(message: "Error parsing nekos-api JSON")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                }
            } catch {
                print("Error decoding nekos-api JSON: \(error)")
                self.showErrorAlert(message: "Error decoding nekos-api JSON")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        task.resume()
    }
}
