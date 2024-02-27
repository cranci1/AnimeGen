//
//  Hmtai.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

extension ViewController {

    func loadImagesFromHmtai() {
        startLoadingIndicator()

        let categories3: [String]
        let endpointPrefix: String

        if UserDefaults.standard.bool(forKey: "enableExplictiCont") {
            categories3 = ["ass", "anal", "bdsm", "classic", "cum", "creampie", "manga", "femdom", "hentai", "incest", "masturbation", "public", "ero", "orgy", "elves", "yuri", "pantsu", "pussy", "glasses", "cuckold", "blowjob", "boobjob", "handjob", "footjob", "boobs", "thighs", "ahegao", "uniform", "gangbang", "tentacles", "gif", "nsfwNeko", "nsfwMobileWallpaper", "zettaiRyouiki"]
            endpointPrefix = "https://hmtai.hatsunia.cfd/nsfw/"
        } else {
            categories3 = ["wave", "wink", "tea", "bonk", "punch", "poke", "bully", "pat", "kiss", "kick", "blush", "feed", "smug", "hug", "cuddle", "cry", "cringe", "slap", "five", "glomp", "happy", "hold", "nom", "smile", "throw", "lick", "bite", "dance", "boop", "sleep", "like", "kill", "tickle", "nosebleed", "threaten", "depression", "wolf_arts", "jahy_arts", "neko_arts", "coffee_arts", "wallpaper", "mobileWallpaper"]
            endpointPrefix = "https://hmtai.hatsunia.cfd/sfw/"
        }

        let randomCategory3 = categories3.randomElement() ?? "pat"

        let apiEndpoint = "\(endpointPrefix)\(randomCategory3)"

        guard let url = URL(string: apiEndpoint) else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error loading image data: \(error.localizedDescription)")
                    self.stopLoadingIndicator()
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid HTTP response")
                    self.stopLoadingIndicator()
                    return
                }

                if let jsonResponse = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any],
                   let imageUrlString = jsonResponse["url"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    print("Image URL: \(imageUrlString)")

                    let imageDataTask = URLSession.shared.dataTask(with: imageUrl) { (imageData, _, imageError) in
                        DispatchQueue.main.async {
                            if let imageError = imageError {
                                print("Error loading image data: \(imageError.localizedDescription)")
                                self.stopLoadingIndicator()
                                return
                            }

                            if let imageData = imageData, let newImage = UIImage(data: imageData) {
                                self.imageView.image = newImage
                                self.animateImageChange(with: newImage)

                                let category3 = randomCategory3
                                self.tagsLabel.isHidden = false
                                self.currentImageURL = imageUrlString
                                self.updateUIWithTags([category3])

                                self.stopLoadingIndicator()
                            } else {
                                print("Invalid image content or link issue.")
                                self.loadImagesFromHmtai()
                            }
                        }
                    }

                    imageDataTask.resume()
                } else {
                    print("Failed to parse JSON response or missing necessary data.")
                    self.stopLoadingIndicator()
                }
            }
        }

        task.resume()
    }

}
