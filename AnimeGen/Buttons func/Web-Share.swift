//
//  Web-Share.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

extension ViewController {
    
    @IBAction func webButtonTapped() {
        guard let urlString = currentImageURL, let url = URL(string: urlString) else {
            print("Invalid URL string: \(currentImageURL ?? "nil")")
            showAlert(withTitle: "Error", message: "The URL is invalid.", viewController: self)
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { success in
            if !success {
                print("Failed to open URL: \(url)")
                self.showAlert(withTitle: "Error", message: "Failed to open the URL.", viewController: self)
            }
        }
    }
    
    @IBAction func shareButtonTapped() {
        guard let currentImage = imageView.image else {
            print("No image available for sharing.")
            showAlert(withTitle: "Error", message: "No image available for sharing.", viewController: self)
            return
        }

        let shareController = UIActivityViewController(activityItems: [currentImage], applicationActivities: nil)
        shareController.popoverPresentationController?.sourceView = view
        present(shareController, animated: true, completion: nil)
    }
}
