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
        
        var apiEndpoint: String
        
        if UserDefaults.standard.bool(forKey: "explicitContents") {
            apiEndpoint = "https://api.nekosapi.com/v3/images/random?limit=1&rating=explicit"
        } else {
            apiEndpoint = "https://api.nekosapi.com/v3/images/random?limit=1&rating=safe"
        }
        
        guard let components = URLComponents(string: apiEndpoint) else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        guard let url = components.url else {
            print("Invalid URL components")
            stopLoadingIndicator()
            return
        }

        let request = URLRequest(url: url)
        fetchImage(with: request)
    }


    private func fetchImage(with request: URLRequest) {
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.stopLoadingIndicator()
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid HTTP response")
                DispatchQueue.main.async {
                    self.stopLoadingIndicator()
                }
                return
            }

            guard let data = data else {
                print("Invalid data")
                DispatchQueue.main.async {
                    self.stopLoadingIndicator()
                }
                return
            }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let images = json["items"] as? [[String: Any]],
                      let imageInfo = images.first,
                      let imageUrlString = imageInfo["image_url"] as? String,
                      let imageTags = imageInfo["tags"] as? [[String: Any]] else {
                    print("Invalid image data or missing tags")
                    DispatchQueue.main.async {
                        self.stopLoadingIndicator()
                    }
                    return
                }
                
                let tags = imageTags.compactMap { $0["name"] as? String }

                guard let imageUrl = URL(string: imageUrlString),
                      let imageData = try? Data(contentsOf: imageUrl),
                      let image = UIImage(data: imageData) else {
                    print("Invalid image data or missing tags")
                    DispatchQueue.main.async {
                        self.stopLoadingIndicator()
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.handleImageLoadingCompletion(with: image, tags: tags, imageUrlString: imageUrlString)
                }
            } catch {
                print("Error parsing JSON: \(error)")
                DispatchQueue.main.async {
                    self.stopLoadingIndicator()
                }
            }
        }.resume()
    }

    private func handleImageLoadingCompletion(with image: UIImage, tags: [String], imageUrlString: String) {
        addImageToHistory(image: image, tags: tags)
        currentImageURL = imageUrlString
        updateUIWithTags(tags)
        addToHistory(image: image)
        tagsLabel.isHidden = false
        imageView.image = image
        animateImageChange(with: image)
        stopLoadingIndicator()
        incrementCounter()
    }
}
