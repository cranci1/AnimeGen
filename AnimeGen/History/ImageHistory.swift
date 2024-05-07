//
//  ImageHistory.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

struct ImageHistory {
    static var images: [UIImage] = []
    
    static func addImage(_ image: UIImage) {
        images.append(image)
    }
}
