//
//  pic-re.swift
//  AnimeGen
//
//  Created by Francesco on 23/02/25.
//

import UIKit

extension ViewController {
    func fetchImageFromPicRe() {
        guard let url = URL(string: "https://pic.re/image") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.custom.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching image from pic.re: \(error)")
                self.showErrorAlert(message: "Failed to load image from pic.re")
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let data = data else {
                print("No data received from pic.re")
                self.showErrorAlert(message: "No data received from pic.re")
                self.activityIndicator.stopAnimating()
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                   let fileURLString = json["file_url"] as? String,
                   let fileURL = URL(string: "https://" + fileURLString) {
                    DispatchQueue.main.async {
                        self.loadImage(from: fileURL)
                    }
                } else {
                    print("Error parsing pic.re JSON or 'file_url' not found")
                    self.showErrorAlert(message: "Error parsing pic.re JSON or 'file_url' not found")
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error decoding pic.re JSON: \(error)")
                self.showErrorAlert(message: "Error decoding pic.re JSON")
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
}
