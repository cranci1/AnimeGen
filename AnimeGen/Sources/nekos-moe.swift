//
//  nekos-moe.swift
//  AnimeGen
//

import Foundation

struct NekosMoeResponse: Decodable {
    struct ImageItem: Decodable {
        let id: String
        let tags: [String]?
        let artist: String?
    }
    let images: [ImageItem]
}

enum NekosMoeAPI {
    static func fetch() async throws -> AnimeArtItem {
        guard let url = URL(string: "https://nekos.moe/api/v1/random/image?count=1&nsfw=false") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.custom.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(NekosMoeResponse.self, from: data)
        guard let first = decoded.images.first,
              let imageURL = URL(string: "https://nekos.moe/image/\(first.id)") else {
            throw URLError(.cannotParseResponse)
        }
        
        return AnimeArtItem(
            imageURL: imageURL,
            source: .nekosMoe,
            category: "Illustration",
            artistName: first.artist,
            artistURL: nil,
            sourceURL: URL(string: "https://nekos.moe/post/\(first.id)"),
            tags: first.tags ?? ["anime", "nekos.moe"],
            isGIF: imageURL.pathExtension.lowercased() == "gif"
        )
    }
}

