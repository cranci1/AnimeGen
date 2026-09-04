//
//  nekos-best.swift
//  AnimeGen
//

import Foundation

struct NekosBestResponse: Decodable {
    struct ResultItem: Decodable {
        let artist_name: String?
        let artist_href: String?
        let source_url: String?
        let url: String
    }
    let results: [ResultItem]
}

enum NekosBestAPI {
    static let portraitCategories = [
        "neko", "waifu", "kitsune", "husbando"
    ]
    static let actionCategories = [
        "hug", "kiss", "pat", "cuddle", "dance", "smile", "blush", "wink", "poke", "happy", "smug"
    ]
    
    static func fetch(orientation: OrientationMode = .any) async throws -> AnimeArtItem {
        let category: String
        switch orientation {
        case .vertical:
            category = portraitCategories.randomElement() ?? "waifu"
        case .horizontal:
            category = actionCategories.randomElement() ?? "hug"
        case .any:
            let all = portraitCategories + actionCategories
            category = all.randomElement() ?? "neko"
        }
        
        guard let url = URL(string: "https://nekos.best/api/v2/\(category)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.custom.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(NekosBestResponse.self, from: data)
        guard let first = decoded.results.first, let imageURL = URL(string: first.url) else {
            throw URLError(.cannotParseResponse)
        }
        
        return AnimeArtItem(
            imageURL: imageURL,
            source: .nekosBest,
            category: category.capitalized,
            artistName: first.artist_name,
            artistURL: first.artist_href.flatMap(URL.init(string:)),
            sourceURL: first.source_url.flatMap(URL.init(string:)),
            tags: [category, "nekos.best"],
            isGIF: imageURL.pathExtension.lowercased() == "gif"
        )
    }
}

