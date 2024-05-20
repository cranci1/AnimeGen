//
//  waifu-it.swift
//  AnimeGen
//
//  Created by cranci on 24/04/24.
//

import UIKit

extension ViewController {
    
    func loadImageFromWaifuIt() {
        startLoadingIndicator()

        let categories: [String]
        let endpointPrefix: String = "https://waifu.it/api/v4/"

        if UserDefaults.standard.bool(forKey: "enableExplicitContent") {
            categories = ["angry", "baka", "bite", "blush", "bonk", "bored", "bully", "bye", "chase", "cheer", "cringe", "cry", "dab", "dance", "die", "disgust", "facepalm", "feed", "glomp", "happy", "hi", "highfive", "hold", "hug", "kick", "kill", "kiss", "laugh", "lick", "love", "lurk", "midfing", "nervous", "nom", "nope", "nuzzle", "panic", "pat", "peck", "poke", "pout", "punch", "run", "sad", "shoot", "shrug", "sip", "slap", "sleepy", "smile", "smug", "stab", "stare", "suicide", "tease", "think", "thumbsup", "tickle", "triggered", "wag", "wave", "wink", "yes"]
        } else {
            categories = ["angry", "baka", "bite", "blush", "bonk", "bored", "bye", "chase", "cheer", "cringe", "cry", "cuddle", "dab", "dance", "disgust", "facepalm", "feed", "glomp", "happy", "hi", "highfive", "hold", "hug", "kick", "kiss", "laugh", "lurk", "nervous", "nom", "nope", "nuzzle", "panic", "pat", "peck", "poke", "pout", "run", "sad", "shrug", "sip", "slap", "sleepy", "smile", "smug", "stare", "tease", "think", "thumbsup", "tickle", "wag", "wave", "wink", "yes"]
        }

        let randomCategory = categories.randomElement() ?? "waifu"

        let apiEndpoint = "\(endpointPrefix)\(randomCategory)"

        guard let url = URL(string: apiEndpoint) else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        var request = URLRequest(url: url)
        request.setValue(Secrets.waifuItToken, forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
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

                if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let imageUrlString = jsonResponse["url"] as? String, let imageUrl = URL(string: imageUrlString) {

                    DispatchQueue.global().async {
                        if let imageData = try? Data(contentsOf: imageUrl) {
                            DispatchQueue.main.async {
                                if imageUrlString.lowercased().hasSuffix(".gif") {
                                    if let animatedImage = UIImage.animatedImage(with: UIImage.gifData(data: imageData) ?? [], duration: 1.0) {
                                        self.handleImageLoadingCompletion(with: animatedImage, tags: [randomCategory], imageUrlString: imageUrlString)
                                    } else {
                                        print("Failed to create animated image from GIF data.")
                                        self.stopLoadingIndicator()
                                    }
                                } else {
                                    if let newImage = UIImage(data: imageData) {
                                        self.handleImageLoadingCompletion(with: newImage, tags: [randomCategory], imageUrlString: imageUrlString)
                                    } else {
                                        print("Failed to load image data.")
                                        self.stopLoadingIndicator()
                                    }
                                }
                            }
                        } else {
                            print("Failed to load image data.")
                            self.stopLoadingIndicator()
                        }
                    }
                } else {
                    print("Failed to parse JSON response or missing necessary data.")
                    self.stopLoadingIndicator()
                }
            }
        }

        task.resume()
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
