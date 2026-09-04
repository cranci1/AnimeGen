//
//  nekos-api.swift
//  AnimeGen
//

import Foundation

struct NekosApiItem: Decodable {
    let id: Int?
    let url: String
    let rating: String?
    let artist_name: String?
    let tags: [String]?
    let source_url: String?
}

enum NekosApiAPI {
    static func fetch() async throws -> AnimeArtItem {
        guard let url = URL(string: "https://api.nekosapi.com/v4/images/random?limit=1&rating=safe") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.custom.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedList = try JSONDecoder().decode([NekosApiItem].self, from: data)
        guard let first = decodedList.first, let imageURL = URL(string: first.url) else {
            throw URLError(.cannotParseResponse)
        }
        
        return AnimeArtItem(
            imageURL: imageURL,
            source: .nekosApi,
            category: "Illustration",
            artistName: first.artist_name,
            artistURL: nil,
            sourceURL: first.source_url.flatMap(URL.init(string:)),
            tags: first.tags ?? ["anime", "nekosapi"],
            isGIF: imageURL.pathExtension.lowercased() == "gif"
        )
    }
}

