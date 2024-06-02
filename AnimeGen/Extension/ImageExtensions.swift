//
//  ImageExtensions.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit
import SDWebImage

extension UIImage {
    var imageData: Data? {
        return self.sd_imageData()
    }
}

extension UIImageView {
    func loadImage(from url: String) {
        if let imageUrl = URL(string: url) {
            self.sd_setImage(with: imageUrl, completed: nil)
        }
    }
}
