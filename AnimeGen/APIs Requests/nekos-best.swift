//
//  nekos-best.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

extension ViewController {
    
    func loadImageFromNekosBest() {
        startLoadingIndicator()

        let categories = ["neko", "waifu", "kitsune"]
        let randomCategory = categories.randomElement() ?? "waifu"

        let apiEndpoint = "https://nekos.best/api/v2/\(randomCategory)"

        guard let url = URL(string: apiEndpoint) else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    self.stopLoadingIndicator()
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid HTTP response")
                    self.stopLoadingIndicator()
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    print("Invalid status code: \(httpResponse.statusCode)")
                    self.stopLoadingIndicator()
                    return
                }
                
                do {
                    if let jsonData = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let results = jsonResponse["results"] as? [[String: Any]],
                       let result = results.first,
                       let imageUrlString = result["url"] as? String,
                       let imageUrl = URL(string: imageUrlString) {

                        self.currentImageURL = imageUrlString

                        let author = result["artist_name"] as? String
                        let category = randomCategory

                        if let data = try? Data(contentsOf: imageUrl), let newImage = UIImage(data: data) {
                            self.imageView.image = newImage
                            self.tagsLabel.isHidden = false
                            self.animateImageChange(with: newImage)
                            self.addToHistory(image: newImage)
                            self.addImageToHistory(image: newImage, tags: [randomCategory])
                            self.updateUIWithTags([], author: author, category: category)
                            self.stopLoadingIndicator()
                            self.incrementCounter()
                        } else {
                            print("Failed to load image data.")
                            self.stopLoadingIndicator()
                        }
                    } else {
                        print("Failed to parse JSON response or missing necessary data.")
                        self.stopLoadingIndicator()
                    }
                }
            }
        }

        task.resume()
    }

}
