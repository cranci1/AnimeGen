//
//  nekosapi.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

extension ViewController {

    func loadImageFromNekosapi() {
        startLoadingIndicator()
        
        var ratings: [String] = ["safe"]

        if UserDefaults.standard.bool(forKey: "enableExplictiCont") {
            ratings.append("explicit")
        }

        let randomRating = ratings.randomElement() ?? "safe"

        let apiEndpoint = "https://api.nekosapi.com/v3/images/random?limit=1&rating=\(randomRating)"
        
        guard let url = URL(string: apiEndpoint) else {
            
            if self.alert {
                self.showAlert(withTitle: "Invalid URL", message: "Please wait, the api may be down.", viewController: self)
            }
            
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    
                    if self.alert {
                        self.showAlert(withTitle: "Error!", message: "\(error)", viewController: self)
                    }
                    
                    print("Error: \(error)")
                    self.stopLoadingIndicator()
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    
                    if self.alert {
                        self.showAlert(withTitle: "Invalid HTTP response", message: "Please wait, the api may be down.", viewController: self)
                    }
                    
                    print("Invalid HTTP response")
                    self.stopLoadingIndicator()
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    
                    if self.alert {
                        self.showAlert(withTitle: "Invalid status code", message: "\(httpResponse.statusCode)", viewController: self)
                    }
                    
                    print("Invalid status code: \(httpResponse.statusCode)")
                    self.stopLoadingIndicator()
                    return
                }

                do {
                    if let jsonData = data,
                        let jsonResponse = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                        let items = jsonResponse["items"] as? [[String: Any]],
                        let firstItem = items.first,
                        let imageUrlString = firstItem["image_url"] as? String,
                        let imageUrl = URL(string: imageUrlString),
                        let tagsArray = firstItem["tags"] as? [[String: Any]] {

                        self.currentImageURL = imageUrlString

                        let tags = tagsArray.compactMap { $0["name"] as? String }

                        if let data = try? Data(contentsOf: imageUrl), let newImage = UIImage(data: data) {
                            self.imageView.image = newImage
                            self.animateImageChange(with: newImage)
                            self.addToHistory(image: newImage)
                            
                            self.tagsLabel.isHidden = false
                            
                            self.updateUIWithTags(tags)

                            self.stopLoadingIndicator()
                            
                            self.incrementCounter()
                        } else {
                            print("Failed to load image data.")
                            self.stopLoadingIndicator()
                            
                            if self.alert {
                                self.showAlert(withTitle: "Error!", message: "Failed to load image data.", viewController: self)
                            }
                            
                        }
                    } else {
                        print("Failed to parse JSON response or missing necessary data.")
                        self.stopLoadingIndicator()
                        
                        if self.alert {
                            self.showAlert(withTitle: "Error!", message: "Failed to parse JSON response or missing data.", viewController: self)
                        }
                    }
                }
            }
        }

        task.resume()
    }

}
