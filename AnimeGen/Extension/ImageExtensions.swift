//
//  ImageExtensions.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit
import SDWebImage

extension UIImage {
    class func gifData(data: Data) -> [UIImage]? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []

        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            images.append(UIImage(cgImage: cgImage))
        }

        return images
    }
    
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

