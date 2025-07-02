//
//  VideoWatchingActivity.swift
//  Sora
//
//  Created by Francesco on 15/06/25.
//

import UIKit
import Foundation
import GroupActivities

struct VideoWatchingActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = mediaTitle
        
        if isMovie {
            metadata.subtitle = "Movie"
        } else {
            metadata.subtitle = "Episode \(episodeNumber)"
        }
        
        if let imageData = episodeImageData,
           let uiImage = UIImage(data: imageData) {
            metadata.previewImage = uiImage.cgImage
        }
        
        metadata.type = .watchTogether
        return metadata
    }
    
    let mediaTitle: String
    let episodeNumber: Int
    let streamUrl: String
    let subtitles: String
    let aniListID: Int
    let fullUrl: String
    let headers: [String: String]?
    let episodeImageUrl: String
    let episodeImageData: Data?
    let totalEpisodes: Int
    let tmdbID: Int?
    let isMovie: Bool
    let seasonNumber: Int
}
