//
//  purr.swift
//  AnimeGen
//
//  Created by cranci on 16/03/24.
//

import UIKit
import SDWebImage

extension ViewController {
    
    func loadImageFromPurr() {
        startLoadingIndicator()
        
        let startTime = DispatchTime.now()
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            var endpointPrefix: String
            var categories: [String] = []
            
            if let selectedTags = UserDefaults.standard.array(forKey: "SelectedTagsPurr") as? [String], !selectedTags.isEmpty {
                categories = selectedTags
            } else {
                if UserDefaults.standard.bool(forKey: "explicitContents") {
                    categories = ["anal/gif", "blowjob/gif", "cum/gif", "fuck/gif", "neko/gif", "pussylick/gif", "solo/gif", "solo_male/gif", "threesome_fff/gif", "threesome_ffm/gif", "threesome_mmf/gif", "yuri/gif", "neko/img"]
                } else {
                    categories = ["angry/gif", "bite/gif", "blush/gif", "comfy/gif", "cry/gif", "cuddle/gif", "dance/gif", "eevee/gif", "fluff/gif", "holo/gif", "hug/gif", "kiss/gif", "lay/gif", "lick/gif", "neko/gif", "pat/gif", "poke/gif", "pout/gif", "slap/gif", "smile/gif", "tail/gif", "tickle/gif", "background/img", "eevee/img", "holo/img", "icon/img", "kitsune/img", "neko/img", "okami/img", "senko/img", "shiro/img"]
                }
            }
            
            if UserDefaults.standard.bool(forKey: "explicitContents") {
                endpointPrefix = "https://purrbot.site/api/img/nsfw/"
            } else {
                endpointPrefix = "https://purrbot.site/api/img/sfw/"
            }
            
            let randomIndex = Int(arc4random_uniform(UInt32(categories.count)))
            let randomCategory = categories[randomIndex]
            
            guard let url = URL(string: "\(endpointPrefix)\(randomCategory)") else {
                print("Invalid URL")
                DispatchQueue.main.async {
                    self.stopLoadingIndicator()
                }
                return
            }
            
            let request = URLRequest(url: url)
            
            self.fetchImage(with: request, startTime: startTime, tag: randomCategory)
        }
    }
    
    private func fetchImage(with request: URLRequest, startTime: DispatchTime, tag: String) {
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
            
            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let imageUrlString = jsonResponse["link"] as? String else {
                print("Invalid image data or missing response headers")
                DispatchQueue.main.async {
                    self.stopLoadingIndicator()
                }
                return
            }
            
            DispatchQueue.main.async {
                let isGif = imageUrlString.hasSuffix(".gif")
                
                if isGif {
                    self.imageView.sd_setImage(with: URL(string: imageUrlString), placeholderImage: nil, options: .allowInvalidSSLCertificates, context: nil, progress: nil, completed: { (image, error, cacheType, url) in
                        if let error = error {
                            print("Error loading GIF image: \(error)")
                        } else {
                            self.handleImageLoadingCompletion(with: image ?? UIImage(), tags: [tag], imageUrlString: imageUrlString)
                        }
                    })
                } else {
                    self.imageView.sd_setImage(with: URL(string: imageUrlString), placeholderImage: nil, options: [], context: nil, progress: nil, completed: { (image, error, cacheType, url) in
                        if let error = error {
                            print("Error loading image: \(error)")
                        } else {
                            self.handleImageLoadingCompletion(with: image ?? UIImage(), tags: [tag], imageUrlString: imageUrlString)
                        }
                    })
                }
                
                let endTime = DispatchTime.now()
                let executionTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                print("Execution time: \(Double(executionTime) / 1_000_000_000) seconds")
            }
        }.resume()
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
        setTagsLines0()
    }
}
