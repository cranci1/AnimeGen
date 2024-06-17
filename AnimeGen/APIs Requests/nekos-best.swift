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

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            var categories: [String] = []
            
            if let selectedTags = UserDefaults.standard.array(forKey: "SelectedTagsNekos.Best") as? [String], !selectedTags.isEmpty {
                categories = selectedTags
            } else {
                categories = ["neko", "waifu", "kitsune"]
            }
            
            let randomIndex = Int(arc4random_uniform(UInt32(categories.count)))
            let randomCategory = categories[randomIndex]

            let apiEndpoint = "https://nekos.best/api/v2/\(randomCategory)"

            guard let url = URL(string: apiEndpoint) else {
                print("Invalid URL")
                DispatchQueue.main.async {
                    self.stopLoadingIndicator()
                }
                return
            }

            let request = URLRequest(url: url)
            
            DispatchQueue.main.async {
                self.fetchImage(with: request, tag: randomCategory)
            }
        }
    }

    private func fetchImage(with request: URLRequest, tag: String) {
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
                      let images = json["results"] as? [[String: Any]],
                      let imageInfo = images.first,
                      let imageUrlString = imageInfo["url"] as? String,
                      let tag = [tag].first
                else {
                    print("Invalid image data or missing tags")
                    DispatchQueue.main.async {
                        self.stopLoadingIndicator()
                    }
                    return
                }

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
                    self.handleImageLoadingCompletion(with: image, tags: [tag], imageUrlString: imageUrlString)
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
        setTagsLines0()
    }
}
