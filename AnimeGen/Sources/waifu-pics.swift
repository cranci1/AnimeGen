import Foundation

struct OtakuGifResponse: Decodable {
    let url: String
}

enum WaifuPicsAPI {
    static let reactions = [
        "hug", "kiss", "pat", "cuddle", "dance", "slap", 
        "poke", "smile", "blush", "wink", "happy", "cry", "pout", "smug"
    ]
    
    static let waifuCategories = [
        "waifu", "neko", "shinobu", "megumin", "cuddle", "hug",
        "kiss", "pat", "smug", "blush", "smile", "wave", "dance", "happy"
    ]
    
    static func fetch(orientation: OrientationMode = .any) async throws -> AnimeArtItem {
        if orientation == .vertical {
            let cat = waifuCategories.randomElement() ?? "waifu"
            guard let url = URL(string: "https://api.waifu.pics/sfw/\(cat)") else {
                throw URLError(.badURL)
            }
            let (data, response) = try await URLSession.custom.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            struct WaifuPicsResp: Decodable {
                let url: String
            }
            let decoded = try JSONDecoder().decode(WaifuPicsResp.self, from: data)
            guard let imageURL = URL(string: decoded.url) else {
                throw URLError(.cannotParseResponse)
            }
            let isGif = decoded.url.lowercased().hasSuffix(".gif")
            return AnimeArtItem(
                imageURL: imageURL,
                source: .waifupics,
                category: cat.capitalized + (isGif ? " GIF" : " Art"),
                artistName: nil,
                artistURL: nil,
                sourceURL: nil,
                tags: [cat, isGif ? "gif" : "anime"],
                isGIF: isGif
            )
        } else {
            let reaction = reactions.randomElement() ?? "hug"
            guard let url = URL(string: "https://api.otakugifs.xyz/gif?reaction=\(reaction)") else {
                throw URLError(.badURL)
            }
            let (data, response) = try await URLSession.custom.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let decoded = try JSONDecoder().decode(OtakuGifResponse.self, from: data)
            guard let imageURL = URL(string: decoded.url) else {
                throw URLError(.cannotParseResponse)
            }
            return AnimeArtItem(
                imageURL: imageURL,
                source: .waifupics,
                category: reaction.capitalized + " GIF",
                artistName: nil,
                artistURL: nil,
                sourceURL: nil,
                tags: [reaction, "gif", "animation"],
                isGIF: true
            )
        }
    }
}

