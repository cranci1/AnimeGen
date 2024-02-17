//
//  ImageExtensions.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

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
}

