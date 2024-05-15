//
//  n-sfw.swift
//  AnimeGen
//
//  Created by cranci on 15/05/24.
//

import UIKit

extension ViewController {

    func loadImageFromNSFW() {
        startLoadingIndicator()

        let categories: [String]
        let endpointPrefix: String

        if UserDefaults.standard.bool(forKey: "enableExplictiCont") {
            categories = ["anal","ass", "blowjob", "breeding", "buttplug", "cages", "ecchi", "feet", "fo", "furry", "gif", "hentai", "legs", "masturbation", "milf", "muscle", "neko", "paizuri", "petgirls", "pierced", "selfie", "smothering", "socks", "trap", "vagina", "yaoi", "yuri"]
            endpointPrefix = "https://api.n-sfw.com/nsfw/"
        } else {
            categories = ["bunny-girl", "charlotte", "date-a-live", "death-note", "demon-slayer", "haikyu", "hxh", "kakegurui", "konosuba", "komi", "memes", "naruto", "noragami", "one-piece", "rag", "sakurasou", "sao", "sds", "spy-x-family", "takagi-san", "toradora", "your-name"]
            endpointPrefix = "https://api.n-sfw.com/sfw/"
        }

        guard let randomCategory = categories.randomElement() else {
            print("Failed to get random category")
            stopLoadingIndicator()
            return
        }

        guard let url = makeURL(with: endpointPrefix, category: randomCategory) else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            guard let data = try? Data(contentsOf: url) else {
                print("Failed to fetch image data.")
                DispatchQueue.main.async {
                    self.stopLoadingIndicator()
                }
                return
            }

            DispatchQueue.main.async {
                self.handleImageData(data, category: randomCategory)
            }
        }
    }

    private func makeURL(with endpointPrefix: String, category: String) -> URL? {
        guard let url = URL(string: endpointPrefix + category) else {
            print("Invalid URL")
            return nil
        }
        return url
    }

    private func handleImageData(_ data: Data, category: String) {
        guard let imageUrl = getImageUrl(from: data) else {
            print("Failed to parse JSON response or missing necessary data.")
            stopLoadingIndicator()
            return
        }

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            guard let imageData = try? Data(contentsOf: imageUrl) else {
                print("Failed to load image data.")
                DispatchQueue.main.async {
                    self.stopLoadingIndicator()
                }
                return
            }

            DispatchQueue.main.async {
                self.loadedImageHandler(imageData, category: category)
            }
        }
    }

    private func loadedImageHandler(_ imageData: Data, category: String) {
        guard let image = UIImage(data: imageData) else {
            print("Failed to create image from data.")
            stopLoadingIndicator()
            return
        }

        self.handleLoadedImage(image, category: category)
    }

    private func handleLoadedImage(_ image: UIImage, category: String) {
        self.imageView.image = image
        self.addImageToHistory(image: image, tags: [category])
        self.animateImageChange(with: image)
        self.addToHistory(image: image)

        self.tagsLabel.isHidden = false
        self.updateUIWithTags([category])
        self.stopLoadingIndicator()
        self.incrementCounter()
    }

    private func getImageUrl(from data: Data) -> URL? {
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let imageUrlString = jsonResponse["url"] as? String,
              let imageUrl = URL(string: imageUrlString) else {
            return nil
        }
        return imageUrl
    }
}
