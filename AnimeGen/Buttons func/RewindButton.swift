//
//  RewindButton.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

extension ViewController {
    
    @IBAction func rewindButtonTapped() {
        if let lastImage = lastImage {
            animateImageChange(with: lastImage)
        }
    }
    
}
