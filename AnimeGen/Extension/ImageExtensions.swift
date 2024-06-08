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
    
    func resized(to targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

extension UIImageView {
    func loadImage(from url: String) {
        if let imageUrl = URL(string: url) {
            self.sd_setImage(with: imageUrl, completed: nil)
        }
    }
}
