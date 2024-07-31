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

        let isNSFW = UserDefaults.standard.bool(forKey: "explicitContents")
        let apiEndpoint = "https://api.waifu.im/search"

        var components = URLComponents(string: apiEndpoint)
        components?.queryItems = [URLQueryItem(name: "is_nsfw", value: isNSFW ? "true" : "false")]

        guard let url = components?.url else {
            print("Invalid URL")
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

            // Use Codable for JSON decoding
            struct ImageInfo: Codable {
                let url: String
                let tags: [Tag]
            }

            struct Tag: Codable {
                let name: String
            }

            struct Response: Codable {
                let images: [ImageInfo]
            }

            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                guard let imageInfo = response.images.first else {
                    print("No images found")
                    DispatchQueue.main.async {
                        self.stopLoadingIndicator()
                    }
                    return
                }

                let tags = imageInfo.tags.map { $0.name }

                guard let imageUrl = URL(string: imageInfo.url) else {
                    print("Invalid image URL")
                    DispatchQueue.main.async {
                        self.stopLoadingIndicator()
                    }
                    return
                }

                // Fetch image data asynchronously
                URLSession.shared.dataTask(with: imageUrl) { [weak self] (imageData, _, error) in
                    guard let self = self else { return }

                    if let error = error {
                        print("Error loading image data: \(error)")
                        DispatchQueue.main.async {
                            self.stopLoadingIndicator()
                        }
                        return
                    }

                    guard let imageData = imageData, let image = UIImage(data: imageData) else {
                        print("Invalid image data")
                        DispatchQueue.main.async {
                            self.stopLoadingIndicator()
                        }
                        return
                    }

                    DispatchQueue.main.async {
                        self.handleImageLoadingCompletion(with: image, tags: tags, imageUrlString: imageInfo.url)
                    }
                }.resume()
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
