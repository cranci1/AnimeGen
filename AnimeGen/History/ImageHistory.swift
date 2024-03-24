//
//  ImageHistory.swift
//  AnimeGen
//
//  Created by cranci on 24/03/24.
//

import UIKit

struct ImageHistory {
    static var images: [UIImage] = []
    
    static func addImage(_ image: UIImage) {
        images.append(image)
    }
}

