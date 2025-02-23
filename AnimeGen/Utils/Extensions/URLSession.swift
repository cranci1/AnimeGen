//
//  AppDelegate.swift
//  AnimeGen
//
//  Created by Francesco on 26/01/25.
//

import Foundation

extension URLSession {
    static let custom: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        ]
        return URLSession(configuration: configuration)
    }()
}
