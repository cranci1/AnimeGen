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
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https://pic.re/image") else {
                print("Invalid URL")
                self.stopLoadingIndicator()
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error: \(error)")
                    self.stopLoadingIndicator()
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid HTTP response")
                    self.stopLoadingIndicator()
                    return
                }
                
                guard let data = data,
                      let imageTagsString = httpResponse.allHeaderFields["image_tags"] as? String,
                      let imageUrlString = httpResponse.allHeaderFields["image_source"] as? String,
                      let newImage = UIImage(data: data) else {
                    print("Invalid image data or missing response headers")
                    self.stopLoadingIndicator()
                    return
                }
                
                let tags = imageTagsString.components(separatedBy: ",")
                
                DispatchQueue.main.async {
                    self.handleImageLoadingCompletion(with: newImage, tags: tags, imageUrlString: imageUrlString)
                    
                    let endTime = DispatchTime.now()
                    let executionTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                    print("Execution time: \(Double(executionTime) / 1_000_000_000) seconds")
                }
            }.resume()
        }
    }
    
    private func handleImageLoadingCompletion(with newImage: UIImage, tags: [String], imageUrlString: String) {
        addImageToHistory(image: newImage, tags: tags)
        currentImageURL = imageUrlString
        updateUIWithTags(tags)
        addToHistory(image: newImage)
        tagsLabel.isHidden = false
        imageView.image = newImage
        animateImageChange(with: newImage)
        stopLoadingIndicator()
        incrementCounter()
    }
}
