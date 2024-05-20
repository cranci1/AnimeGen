//
//  HmtaiSender.swift
//  AnimeGen
//
//  Created by cranci on 03/03/24.
//

import UIKit

extension ViewController {
    
    @objc func startHmtaiLoader() {
        startLoadingIndicator()

        let categories3: [String]
        let endpointPrefix: String

        if UserDefaults.standard.bool(forKey: "enableExplicitContent") {
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
            self.stopLoadingIndicator()
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                if let imageUrlString = json?["url"] as? String {
                    DispatchQueue.main.async { [weak self] in
                        self?.sendImageToDiscord(imageUrlString)
                        
                        let category3 = randomCategory3
                        self?.tagsLabel.isHidden = false
                        self?.updateUIWithTags([category3])
                    }
                } else {
                    print("Error: Could not find 'url' field in the API response.")
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    private func sendImageToDiscord(_ imageUrlString: String) {
        let discordWebhookURL = Secrets.discordWebhookURL

        var request = URLRequest(url: discordWebhookURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = ["content": imageUrlString]
        let jsonData = try? JSONSerialization.data(withJSONObject: payload)

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error sending image URL to Discord: \(error.localizedDescription)")
            } else {
                self?.fetchLastMessageFromDiscordAndLoadImage()
            }
        }.resume()
    }
}
