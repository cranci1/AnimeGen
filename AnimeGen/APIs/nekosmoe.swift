//
//  nekosmoe.swift
//  AnimeGen
//
//  Created by cranci on 18/02/24.
//

import UIKit

extension ViewController {

    func loadImageAndTagsFromNekosMoe() {
        startLoadingIndicator()

        let isNSFW = UserDefaults.standard.bool(forKey: "enableExplictiCont")
        let moetags = UserDefaults.standard.bool(forKey: "enableMoeTags")

        let apiEndpoint = "https://nekos.moe/api/v1/random/image"

        var components = URLComponents(string: apiEndpoint)
        components?.queryItems = [
            URLQueryItem(name: "nsfw", value: isNSFW.description.lowercased())
        ]

        guard let url = components?.url else {
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
                       let images = jsonResponse["images"] as? [[String: Any]],
                       let firstImage = images.first {

                        let imageId = firstImage["id"] as? String

                        if moetags {
                            if let tagsArray = firstImage["tags"] as? [String] {
                                // Print tags for debugging
                                print("Tags: \(tagsArray)")

                                // Update UI with tags
                                self.updateUIWithTags(tagsArray)

                                var newComponents = URLComponents(string: "https://nekos.moe/thumbnail/\(imageId ?? "")")
                                newComponents?.queryItems = [
                                    URLQueryItem(name: "tags", value: tagsArray.joined(separator: ","))
                                    // Add more query parameters as needed
                                ]

                                guard let newUrl = newComponents?.url else {
                                    print("Invalid URL with tags")
                                    self.stopLoadingIndicator()
                                    return
                                }

                                let imageRequest = URLRequest(url: newUrl)
                                let imageTask = URLSession.shared.dataTask(with: imageRequest) { (imageData, _, imageError) in
                                    DispatchQueue.main.async {
                                        if let imageError = imageError {
                                            print("Image loading error: \(imageError)")
                                            self.stopLoadingIndicator()
                                            return
                                        }

                                        if let imageData = imageData, let newImage = UIImage(data: imageData) {
                                            self.imageView.image = newImage
                                            self.animateImageChange(with: newImage)

                                            // Continue with the rest of your code here
                                            // Add any additional logic or UI updates you need

                                            // Temporarily hide the tag label when using nekos.moe API
                                            self.tagsLabel.isHidden = true

                                            self.stopLoadingIndicator()
                                        } else {
                                            print("Failed to load image data with tags.")
                                            self.stopLoadingIndicator()
                                        }
                                    }
                                }

                                imageTask.resume()
                            } else {
                                print("Tags data not available.")
                                self.stopLoadingIndicator()
                            }
                        } else {
                            // Load the image without tags
                            var newComponents = URLComponents(string: "https://nekos.moe/thumbnail/\(imageId ?? "")")

                            guard let newUrl = newComponents?.url else {
                                print("Invalid URL without tags")
                                self.stopLoadingIndicator()
                                return
                            }

                            let imageRequest = URLRequest(url: newUrl)
                            let imageTask = URLSession.shared.dataTask(with: imageRequest) { (imageData, _, imageError) in
                                DispatchQueue.main.async {
                                    if let imageError = imageError {
                                        print("Image loading error: \(imageError)")
                                        self.stopLoadingIndicator()
                                        return
                                    }

                                    if let imageData = imageData, let newImage = UIImage(data: imageData) {
                                        self.imageView.image = newImage
                                        self.animateImageChange(with: newImage)

                                        // Continue with the rest of your code here
                                        // Add any additional logic or UI updates you need

                                        // Temporarily hide the tag label when using nekos.moe API
                                        self.tagsLabel.isHidden = true

                                        self.stopLoadingIndicator()
                                    } else {
                                        print("Failed to load image data without tags.")
                                        self.stopLoadingIndicator()
                                    }
                                }
                            }

                            imageTask.resume()
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
