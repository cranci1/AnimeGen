//
//  Tags.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

extension ViewController {
    
    func updateUIWithTags(_ tags: [String], author: String? = nil, category: String? = nil) {
        guard UserDefaults.standard.bool(forKey: "enableTags") else {
            tagsLabel.attributedText = nil
            return
        }
        
        var components = [String]()
        
        if !tags.isEmpty {
            components.append("Tags: \(tags.joined(separator: ", "))")
        }
        
        if let author = author, !author.isEmpty {
            components.append("Author: \(author)")
        }
        
        if let category = category, !category.isEmpty {
            components.append("Category: \(category)")
        }
        
        let tagsString = components.joined(separator: "\n")
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
