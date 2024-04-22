//
//  Gradient.swift
//  AnimeGen
//
//  Created by cranci on 22/04/24.
//

import UIKit

extension ViewController {
    
    func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0).cgColor, UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func animateGradient() {
        let gradientLayer = view.layer.sublayers?.first as! CAGradientLayer
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0, 0]
        animation.toValue = [1, 1]
        animation.duration = 5.0
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "locationsAnimation")
    }
    
}
