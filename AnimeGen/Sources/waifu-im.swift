//
//  waifu-im.swift
//  AnimeGen
//

import Foundation

struct WaifuImResponse: Decodable {
    struct ImageItem: Decodable {
        let url: String
        let signature: String?
        let extension_name: String?
        let artist: ArtistInfo?
        
        struct ArtistInfo: Decodable {
            let name: String?
            let patreon: String?
            let pixiv: String?
            let twitter: String?
        }
    }
    let images: [ImageItem]
}

enum WaifuImAPI {
    static func fetch() async throws -> AnimeArtItem {
        guard let url = URL(string: "https://api.waifu.im/search?included_tags=waifu") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("AnimeGen/3.1 (iOS)", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.custom.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(
                domain: "WaifuImAPI",
                code: (response as? HTTPURLResponse)?.statusCode ?? 503,
                userInfo: [NSLocalizedDescriptionKey: "Waifu.im server is currently under maintenance (Cloudflare protection)."]
            )
        }
        
        let decoded = try JSONDecoder().decode(WaifuImResponse.self, from: data)
        guard let first = decoded.images.first, let imageURL = URL(string: first.url) else {
            throw URLError(.cannotParseResponse)
        }
        
        return AnimeArtItem(
            imageURL: imageURL,
            source: .waifuIm,
            category: "Waifu",
            artistName: first.artist?.name,
            artistURL: first.artist?.pixiv.flatMap(URL.init(string:)) ?? first.artist?.twitter.flatMap(URL.init(string:)),
            sourceURL: imageURL,
            tags: ["waifu", "waifu.im"],
            isGIF: imageURL.pathExtension.lowercased() == "gif"
        )
    }
}


