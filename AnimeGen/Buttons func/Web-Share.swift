//
//  Web-Share.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

extension ViewController {
    
    @objc func webButtonTapped() {
        if let urlString = currentImageURL, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func shareButtonTapped() {
        guard let currentImage = imageView.image else {
            print("No image available for sharing.")
            return
        }

        let shareController = UIActivityViewController(
            activityItems: [currentImage],
            applicationActivities: nil
        )
        
            shareController.popoverPresentationController?.sourceView = view
            present(shareController, animated: true, completion: nil)
    }
    
}
