//
//  TraktPushUpdates.swift
//  Sulfur
//
//  Created by Francesco on 13/04/25.
//

import UIKit
import Security

class TraktMutation {
    let apiURL = URL(string: "https://api.trakt.tv")!
    
    func getTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: TraktToken.serviceName,
            kSecAttrAccount as String: TraktToken.accessTokenKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let tokenData = item as? Data,
              let token = String(data: tokenData, encoding: .utf8) else {
            return nil
        }
        return token
    }
    
    func markAsWatched(type: String, tmdbID: Int, episodeNumber: Int? = nil, seasonNumber: Int? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        let sendTraktUpdates = UserDefaults.standard.object(forKey: "sendTraktUpdates") as? Bool ?? true
        if !sendTraktUpdates {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Trakt updates disabled by user"])))
            return
        }
        
        guard let userToken = getTokenFromKeychain() else {
            Logger.shared.log("Trakt access token not found in keychain", type: "Error")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Access token not found"])))
            return
        }
        
        let endpoint = "/sync/history"
        let watchedAt = ISO8601DateFormatter().string(from: Date())
        let body: [String: Any]
        
        switch type {
        case "movie":
            body = [
                "movies": [
                    [
                        "ids": ["tmdb": tmdbID],
                        "watched_at": watchedAt
                    ]
                ]
            ]
            
        case "episode":
            guard let episode = episodeNumber, let season = seasonNumber else {
                let errorMsg = "Missing episode (\(episodeNumber ?? -1)) or season (\(seasonNumber ?? -1)) number"
                Logger.shared.log(errorMsg, type: "Error")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMsg])))
                return
            }
            
            Logger.shared.log("Preparing episode watch request - TMDB ID: \(tmdbID), Season: \(season), Episode: \(episode)", type: "Debug")
            body = [
                "shows": [
                    [
                        "ids": ["tmdb": tmdbID],
                        "seasons": [
                            [
                                "number": season,
                                "episodes": [
                                    [
                                        "number": episode,
                                        "watched_at": watchedAt
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
            
        default:
            Logger.shared.log("Invalid content type: \(type)", type: "Error")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid content type"])))
            return
        }
        
        var request = URLRequest(url: apiURL.appendingPathComponent(endpoint))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
        request.setValue("2", forHTTPHeaderField: "trakt-api-version")
        request.setValue(TraktToken.clientID, forHTTPHeaderField: "trakt-api-key")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
            request.httpBody = jsonData
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                Logger.shared.log("Trakt API Request Body: \(jsonString)", type: "Debug")
            }
        } catch {
            Logger.shared.log("Failed to serialize request body: \(error.localizedDescription)", type: "Error")
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                Logger.shared.log("Trakt API network error: \(error.localizedDescription)", type: "Error")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Logger.shared.log("Trakt API: No HTTP response received", type: "Error")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No HTTP response"])))
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                Logger.shared.log("Trakt API Response Body: \(responseString)", type: "Debug")
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                Logger.shared.log("Successfully updated watch status on Trakt for \(type)", type: "General")
                completion(.success(()))
            } else {
                var errorMessage = "HTTP \(httpResponse.statusCode)"
                if let data = data,
                   let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let error = errorJson["error"] as? String {
                        errorMessage = "\(errorMessage): \(error)"
                    }
                    if let errorDescription = errorJson["error_description"] as? String {
                        errorMessage = "\(errorMessage) - \(errorDescription)"
                    }
                }
                Logger.shared.log("Trakt API Error: \(errorMessage)", type: "Error")
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }
        
        task.resume()
    }
}
