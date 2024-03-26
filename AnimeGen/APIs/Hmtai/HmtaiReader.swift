//
//  HmtaiReader.swift
//  AnimeGen
//
//  Created by cranci on 03/03/24.
//

import UIKit

extension ViewController {
    
    func fetchLastMessageFromDiscordAndLoadImage() {
        
        let discordChannelID = Secrets.discordChannelId
        
        let url = URL(string: "https://discord.com/api/v10/channels/\(discordChannelID)/messages")!
        var request = URLRequest(url: url)
        request.setValue(Secrets.apiToken, forHTTPHeaderField: "Authorization")
        print("Sending request to message JSON")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]], let message = json.first {
                if let imageUrl = self.extractImageUrl(from: message) {
                    self.loadImageFromDiscord(imageUrl: imageUrl)
                    print("Success now step 2")
                } else {
                    print("Error extracting image URL from Discord message.")
                    print("Message JSON: \(self.convertDictionaryToJsonString(message) ?? "")")
                }
            }
        }

        task.resume()
    }
    
    func extractImageUrl(from message: [String: Any]) -> String? {
        if let embeds = message["embeds"] as? [[String: Any]], let embed = embeds.first {
            if let type = embed["type"] as? String, type == "image", let thumbnail = embed["thumbnail"] as? [String: Any] {
                if let proxyUrl = thumbnail["proxy_url"] as? String {
                    return proxyUrl
                } else if let url = thumbnail["url"] as? String {
                    return url
                }
            }
        }

        return nil
    }

    func loadImageFromDiscord(imageUrl: String) {
        DispatchQueue.main.async {
            self.imageView.loadImage(from: imageUrl)
            self.currentImageURL = imageUrl
            self.stopLoadingIndicator()
            self.incrementCounter()
        }
    }
    
    func convertDictionaryToJsonString(_ dictionary: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error converting dictionary to JSON string: \(error)")
            return nil
        }
    }
}
