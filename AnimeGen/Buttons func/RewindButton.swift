//
//  RewindButton.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

extension ViewController {
    
    func addImageToHistory(image: UIImage, tags: [String]) {
        currentPosition += 1
        imageHistory.append((image, tags))
    }
        
    @objc func rewindButtonTapped() {
        if currentPosition > 0 {
            currentPosition -= 1
            let (previousImage, previousTags) = imageHistory[currentPosition]
            DispatchQueue.main.async {
                self.imageView.image = previousImage
                self.updateUIWithTags(previousTags)
                self.animateImageChange(with: previousImage)
            }
        }
    }
    
}
