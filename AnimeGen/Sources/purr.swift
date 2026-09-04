//
//  purr.swift
//  AnimeGen
//

import Foundation

struct PurrResponse: Decodable {
    let link: String
    let error: Bool?
}

enum PurrAPI {
    static let portraitCategories = [
        "background/img", "waifu/img", "neko/img", "senko/img", "shiro/img", "holo/img", "kitsune/img", "okami/img", "eevee/img"
    ]
    static let actionCategories = [
        "dance/gif", "hug/gif", "kiss/gif", "pat/gif", "smile/gif", "cuddle/gif", "fluff/gif"
    ]
    
    static func fetch(orientation: OrientationMode = .any) async throws -> AnimeArtItem {
        let category: String
        switch orientation {
        case .vertical:
            category = portraitCategories.randomElement() ?? "background/img"
        case .horizontal:
            category = actionCategories.randomElement() ?? "hug/gif"
        case .any:
            let all = portraitCategories + actionCategories
            category = all.randomElement() ?? "neko/img"
        }
        
        guard let url = URL(string: "https://api.purrbot.site/v2/img/sfw/\(category)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.custom.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(PurrResponse.self, from: data)
        guard let imageURL = URL(string: decoded.link) else {
            throw URLError(.cannotParseResponse)
        }
        
        let name = category.components(separatedBy: "/").first?.capitalized ?? "Purr"
        return AnimeArtItem(
            imageURL: imageURL,
            source: .purr,
            category: name,
            artistName: nil,
            artistURL: nil,
            sourceURL: nil,
            tags: [name, "purrbot"],
            isGIF: imageURL.pathExtension.lowercased() == "gif"
        )
    }
}

