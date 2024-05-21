//
//  waifu-it.swift
//  AnimeGen
//
//  Created by cranci on 24/04/24.
//

import UIKit
import SDWebImage

extension ViewController {
    
    func loadImageFromWaifuIt() {
        startLoadingIndicator()
        
        let startTime = DispatchTime.now()
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let categories: [String]
            let endpointPrefix: String = "https://waifu.it/api/v4/"

            if UserDefaults.standard.bool(forKey: "explicitContents") {
                categories = ["angry", "baka", "bite", "blush", "bonk", "bored", "bully", "bye", "chase", "cheer", "cringe", "cry", "dab", "dance", "die", "disgust", "facepalm", "feed", "glomp", "happy", "hi", "highfive", "hold", "hug", "kick", "kill", "kiss", "laugh", "lick", "love", "lurk", "midfing", "nervous", "nom", "nope", "nuzzle", "panic", "pat", "peck", "poke", "pout", "punch", "run", "sad", "shoot", "shrug", "sip", "slap", "sleepy", "smile", "smug", "stab", "stare", "suicide", "tease", "think", "thumbsup", "tickle", "triggered", "wag", "wave", "wink", "yes"]
            } else {
                categories = ["angry", "baka", "bite", "blush", "bonk", "bored", "bye", "chase", "cheer", "cringe", "cry", "cuddle", "dab", "dance", "disgust", "facepalm", "feed", "glomp", "happy", "hi", "highfive", "hold", "hug", "kick", "kiss", "laugh", "lurk", "nervous", "nom", "nope", "nuzzle", "panic", "pat", "peck", "poke", "pout", "run", "sad", "shrug", "sip", "slap", "sleepy", "smile", "smug", "stare", "tease", "think", "thumbsup", "tickle", "wag", "wave", "wink", "yes"]
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
            
            var request = URLRequest(url: url)
        
            request.setValue(Secrets.waifuItToken, forHTTPHeaderField: "Authorization")
            
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
                  let imageUrlString = jsonResponse["url"] as? String else {
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
    }
}
