//
//  Tags.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

extension ViewController {

    func updateUIWithTags(_ tags: [String], category: String? = nil) {
        var tagsString = ""

        if UserDefaults.standard.bool(forKey: "enableTags") && !tags.isEmpty {
            tagsString += "Tags: \(tags.joined(separator: ", "))"
        }

        if let category = category, !category.isEmpty {
            if !tagsString.isEmpty {
                tagsString += "\n"
            }
            tagsString += "Category: \(category)"
        }

        let attributedString = NSMutableAttributedString(string: tagsString)

        if !tags.isEmpty {
            let boldRange = NSRange(location: 0, length: min(5, tagsString.count))
            let boldAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            attributedString.addAttributes(boldAttributes, range: boldRange)
        }

        tagsLabel.attributedText = attributedString
    }

    func startLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    func stopLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    func animateFeedback() {
        guard UserDefaults.standard.bool(forKey: "enableAnimations") else {
            return
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.imageView.transform = .identity
            }
        }
    }

    func animateImageChange(with newImage: UIImage) {
        guard UserDefaults.standard.bool(forKey: "enableAnimations") else {
            imageView.image = newImage
            return
        }

        UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imageView.image = newImage
        }, completion: nil)
    }
}
