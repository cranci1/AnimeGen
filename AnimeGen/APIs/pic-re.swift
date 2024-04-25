//
//  pic-re.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

extension ViewController {
    
    func loadImageFromPicRe() {
        startLoadingIndicator()

        let apiEndpoint = "https://pic.re/image"

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

            if let imageTagsString = httpResponse.allHeaderFields["image_tags"] as? String,
               let imageUrlString = httpResponse.allHeaderFields["image_source"] as? String {
                let tags = imageTagsString.components(separatedBy: ",")

                self.currentImageURL = imageUrlString

                DispatchQueue.main.async {
                    self.updateUIWithTags(tags)
                }
            } else {
                print("No image tags found in response headers.")
                
                if self.alert {
                    self.showAlert(withTitle: "Error!", message: "No image tags found in response headers.", viewController: self)
                }
                
                self.stopLoadingIndicator()
                return
            }

            guard let data = data, let newImage = UIImage(data: data) else {
                print("Invalid image data")
                
                if self.alert {
                    self.showAlert(withTitle: "Error!", message: "Invalid image data.", viewController: self)
                }
                
                self.stopLoadingIndicator()
                return
            }

            DispatchQueue.main.async {
                
                self.tagsLabel.isHidden = false
                
                self.addToHistory(image: newImage)
                self.imageView.image = newImage
                
                self.animateImageChange(with: newImage)
                self.stopLoadingIndicator()
                
                self.incrementCounter()
            }
        }

        task.resume()
    }
}
