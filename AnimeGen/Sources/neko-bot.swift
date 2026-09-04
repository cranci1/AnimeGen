//
//  neko-bot.swift
//  AnimeGen
//

import Foundation

struct NekoBotResponse: Decodable {
    let success: Bool
    let message: String
}

enum NekoBotAPI {
    static let portraitCategories = ["neko", "kemonomimi"]
    static let actionCategories = ["coffee", "food"]
    
    static func fetch(orientation: OrientationMode = .any) async throws -> AnimeArtItem {
        let category: String
        switch orientation {
        case .vertical:
            category = portraitCategories.randomElement() ?? "neko"
        case .horizontal:
            category = actionCategories.randomElement() ?? "food"
        case .any:
            let all = portraitCategories + actionCategories
            category = all.randomElement() ?? "neko"
        }
        
        guard let url = URL(string: "https://nekobot.xyz/api/image?type=\(category)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.custom.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(NekoBotResponse.self, from: data)
        guard decoded.success, let imageURL = URL(string: decoded.message) else {
            throw URLError(.cannotParseResponse)
        }
        
        return AnimeArtItem(
            imageURL: imageURL,
            source: .nekoBot,
            category: category.capitalized,
            artistName: nil,
            artistURL: nil,
            sourceURL: nil,
            tags: [category, "nekobot"],
            isGIF: imageURL.pathExtension.lowercased() == "gif"
        )
    }
}

