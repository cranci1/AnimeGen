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
        
        let startTime = DispatchTime.now()
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            guard let url = URL(string: "https://pic.re/image") else {
                self.handleLoadingError("Invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            self.fetchImage(with: request, startTime: startTime)
        }
    }
    
    private func fetchImage(with request: URLRequest, startTime: DispatchTime) {
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.handleLoadingError("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.handleLoadingError("Invalid HTTP response")
                return
            }
            
            guard let data = data,
                  let imageTagsString = httpResponse.allHeaderFields["image_tags"] as? String,
                  let imageUrlString = httpResponse.allHeaderFields["image_source"] as? String,
                  let newImage = UIImage(data: data) else {
                self.handleLoadingError("Invalid image data or missing response headers")
                return
            }
            
            let tags = imageTagsString.components(separatedBy: ",")
            
            DispatchQueue.main.async {
                self.handleImageLoadingCompletion(with: newImage, tags: tags, imageUrlString: imageUrlString, startTime: startTime)
            }
        }.resume()
    }
    
    private func handleImageLoadingCompletion(with newImage: UIImage, tags: [String], imageUrlString: String, startTime: DispatchTime) {
        addImageToHistory(image: newImage, tags: tags)
        currentImageURL = imageUrlString
        updateUIWithTags(tags)
        addToHistory(image: newImage)
        tagsLabel.isHidden = false
        imageView.image = newImage
        animateImageChange(with: newImage)
        stopLoadingIndicator()
        incrementCounter()
        setTagsLines0()
        
        let endTime = DispatchTime.now()
        let executionTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        print("Execution time: \(Double(executionTime) / 1_000_000_000) seconds")
    }
    
    private func handleLoadingError(_ errorMessage: String) {
        print(errorMessage)
        DispatchQueue.main.async {
            self.stopLoadingIndicator()
        }
    }
}
