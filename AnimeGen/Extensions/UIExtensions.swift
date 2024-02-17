//
//  UIExtensions.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

extension ViewController {

    func updateUIWithTags(_ tags: [String], author: String? = nil, category: String? = nil) {
        var tagsString = "Tags: \(tags.joined(separator: ", "))"

        if let author = author, let category = category {
            tagsString += "\nAuthor: \(author)"
            tagsString += "\nCategory: \(category)"
        }

        let attributedString = NSMutableAttributedString(string: tagsString)

        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]

        attributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 5))

        tagsLabel.attributedText = attributedString
    }

    func startLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    func stopLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    func animateFeedback() {
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.imageView.transform = CGAffineTransform.identity
            }
        }
    }

    func animateImageChange(with newImage: UIImage) {
        UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imageView.image = newImage
        }, completion: nil)
    }
}
