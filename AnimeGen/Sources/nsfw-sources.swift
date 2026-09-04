//
//  nsfw-sources.swift
//  AnimeGen
//

import Foundation

// MARK: - Danbooru API (SFW & NSFW)

public struct DanbooruPostItem: Decodable {
    public let id: Int
    public let file_url: String?
    public let large_file_url: String?
    public let preview_file_url: String?
    public let tag_string_character: String?
    public let tag_string_artist: String?
    public let tag_string_general: String?
    public let source: String?
    public let rating: String?
}

public enum DanbooruAPI {
    public static func fetch(isNSFW: Bool = false) async throws -> AnimeArtItem {
        let tagQuery = isNSFW ? "rating:e" : "rating:g+1girl"
        let randomPage = Int.random(in: 1...25)
        guard let url = URL(string: "https://danbooru.donmai.us/posts.json?tags=\(tagQuery)&limit=20&page=\(randomPage)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("AnimeGen/3.1 (iOS)", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 8.0
        
        let (data, response) = try await URLSession.custom.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let posts = try JSONDecoder().decode([DanbooruPostItem].self, from: data)
        guard let post = posts.filter({ ($0.large_file_url ?? $0.file_url) != nil }).randomElement(),
              let imgStr = post.large_file_url ?? post.file_url,
              let imageURL = URL(string: imgStr) else {
            throw URLError(.cannotParseResponse)
        }
        
        let character = post.tag_string_character?.components(separatedBy: " ").first?.replacingOccurrences(of: "_", with: " ").capitalized
        let artist = post.tag_string_artist?.components(separatedBy: " ").first?.replacingOccurrences(of: "_", with: " ")
        let isGif = imageURL.pathExtension.lowercased() == "gif"
        
        return AnimeArtItem(
            imageURL: imageURL,
            source: isNSFW ? .danbooruNSFW : .waifuIm,
            category: character ?? (isNSFW ? "R-18 Artwork" : "Waifu"),
            artistName: artist,
            artistURL: post.source.flatMap(URL.init(string:)),
            sourceURL: URL(string: "https://danbooru.donmai.us/posts/\(post.id)"),
            tags: (post.tag_string_general ?? "").components(separatedBy: " ").filter { !$0.isEmpty },
            isGIF: isGif
        )
    }
}

// MARK: - NekoBot NSFW API (Hentai & 18+ GIFs)

public enum NekoBotNSFWAPI {
    private static let staticTypes = ["hentai", "gonewild", "4k", "ass", "pussy", "thigh", "paizuri", "boobs"]
    private static let gifTypes = ["pgif"]
    
    public static func fetch(isGIFOnly: Bool = false) async throws -> AnimeArtItem {
        let chosenType = isGIFOnly ? (gifTypes.randomElement() ?? "pgif") : (staticTypes.randomElement() ?? "hentai")
        guard let url = URL(string: "https://nekobot.xyz/api/image?type=\(chosenType)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("AnimeGen/3.1 (iOS)", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 8.0
        
        let (data, response) = try await URLSession.custom.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        struct NekoBotResp: Decodable {
            let success: Bool
            let message: String
        }
        
        let decoded = try JSONDecoder().decode(NekoBotResp.self, from: data)
        guard decoded.success, let imageURL = URL(string: decoded.message) else {
            throw URLError(.cannotParseResponse)
        }
        
        let isGif = isGIFOnly || decoded.message.lowercased().hasSuffix(".gif")
        return AnimeArtItem(
            imageURL: imageURL,
            source: isGIFOnly ? .nekoBotNSFWGIF : .nekoBotHentai,
            category: chosenType.capitalized + (isGif ? " GIF (18+)" : " (18+)"),
            artistName: nil,
            artistURL: nil,
            sourceURL: nil,
            tags: ["nsfw", "18+", chosenType, isGif ? "gif" : "art"],
            isGIF: isGif
        )
    }
}

// MARK: - PurrBot NSFW API (Adult 60 FPS GIFs)

public enum PurrBotNSFWAPI {
    private static let nsfwCategories = [
        "yuri", "fuck", "cum", "blowjob", "anal", "solo", "pussylick"
    ]
    
    public static func fetch() async throws -> AnimeArtItem {
        let cat = nsfwCategories.randomElement() ?? "yuri"
        guard let url = URL(string: "https://purrbot.site/api/img/nsfw/\(cat)/gif") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("AnimeGen/3.1 (iOS)", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 8.0
        
        let (data, response) = try await URLSession.custom.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        struct PurrResp: Decodable {
            let link: String
            let error: Bool
        }
        
        let decoded = try JSONDecoder().decode(PurrResp.self, from: data)
        guard !decoded.error, let imageURL = URL(string: decoded.link) else {
            throw URLError(.cannotParseResponse)
        }
        
        return AnimeArtItem(
            imageURL: imageURL,
            source: .purrNSFW,
            category: cat.capitalized + " GIF (18+)",
            artistName: nil,
            artistURL: nil,
            sourceURL: nil,
            tags: ["nsfw", "18+", "purrbot", cat, "gif"],
            isGIF: true
        )
    }
}
