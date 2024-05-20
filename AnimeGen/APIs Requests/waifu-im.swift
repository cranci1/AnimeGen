//
//  waifu-im.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

extension ViewController {

    func loadImageFromWaifuIm() {
        startLoadingIndicator()

        let isNSFW = UserDefaults.standard.bool(forKey: "enableExplicitContent")
        let apiEndpoint = "https://api.waifu.im/search"

        guard var components = URLComponents(string: apiEndpoint) else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }
        components.queryItems = [
            URLQueryItem(name: "is_nsfw", value: isNSFW ? "true" : "false")
        ]

        guard let url = components.url else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                defer {
                    self.stopLoadingIndicator()
                }

                if let error = error {
                    print("Error: \(error)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid HTTP response")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                do {
                    guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let images = jsonResponse["images"] as? [[String: Any]],
                          let firstImage = images.first,
                          let imageUrlString = firstImage["url"] as? String,
                          let imageUrl = URL(string: imageUrlString),
                          let tagsArray = firstImage["tags"] as? [[String: Any]] else {
                        print("Failed to parse JSON response or missing necessary data.")
                        return
                    }

                    self.currentImageURL = imageUrlString

                    let tags = tagsArray.compactMap { $0["name"] as? String }

                    guard let imageData = try? Data(contentsOf: imageUrl),
                          let newImage = UIImage(data: imageData) else {
                        print("Failed to load image data.")
                        return
                    }

                    self.handleImageLoadingCompletion(with: newImage, andTags: tags)

                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }

    private func handleImageLoadingCompletion(with image: UIImage, andTags tags: [String]) {
        DispatchQueue.main.async {
            self.imageView.image = image
            self.addToHistory(image: image)
            self.animateImageChange(with: image)
            self.tagsLabel.isHidden = false
            self.addImageToHistory(image: image, tags: tags)
            self.updateUIWithTags(tags)
            self.incrementCounter()
        }
    }
}
