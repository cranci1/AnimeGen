//
//  pic-re.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

class ImageCache {
    private var cache: NSCache<NSURL, UIImage> = NSCache()

    func image(for url: NSURL) -> UIImage? {
        return cache.object(forKey: url)
    }

    func insertImage(_ image: UIImage?, for url: NSURL) {
        guard let image = image else { return }
        cache.setObject(image, forKey: url)
    }
}

extension ViewController {
    
    private var imageCache: ImageCache {
        return ImageCache()
    }

    func loadImageFromPicRe() {
        startLoadingIndicator()
        
        guard let url = URL(string: "https://pic.re/image") else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }
        
        let startTime = Date()
        
        DispatchQueue.global().async {
            self.fetchImageData(from: url, startTime: startTime)
        }
    }
    
    private func fetchImageData(from url: URL, startTime: Date) {
        if let cachedImage = imageCache.image(for: url as NSURL) {
            handleImageLoadingCompletion(with: cachedImage, tags: [], imageUrlString: url.absoluteString, startTime: startTime)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let error = error {
                self.handleError("Error: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let imageTagsString = httpResponse.allHeaderFields["image_tags"] as? String,
                  let imageUrlString = httpResponse.allHeaderFields["image_source"] as? String,
                  let data = data, let newImage = UIImage(data: data) else {
                self.handleError("Invalid HTTP response or data")
                return
            }

            self.imageCache.insertImage(newImage, for: url as NSURL)

            let tags = imageTagsString.components(separatedBy: ",")

            DispatchQueue.main.async {
                self.handleImageLoadingCompletion(with: newImage, tags: tags, imageUrlString: imageUrlString, startTime: startTime)
            }
        }.resume()
    }
    
    private func handleError(_ message: String) {
        print(message)
        DispatchQueue.main.async {
            self.stopLoadingIndicator()
        }
    }
    
    private func handleImageLoadingCompletion(with newImage: UIImage, tags: [String], imageUrlString: String, startTime: Date) {
        addImageToHistory(image: newImage, tags: tags)
        currentImageURL = imageUrlString
        updateUIWithTags(tags)
        addToHistory(image: newImage)
        tagsLabel.isHidden = false
        imageView.image = newImage
        animateImageChange(with: newImage)
        stopLoadingIndicator()
        incrementCounter()
        
        let executionTime = Date().timeIntervalSince(startTime)
        print("Execution time: \(executionTime) seconds")
    }
}
