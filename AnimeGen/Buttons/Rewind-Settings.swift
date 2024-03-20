//
//  Rewind-Settings.swift
//  AnimeGen
//
//  Created by cranci on 20/03/24.
//

import SwiftUI

extension ViewController {
    
    @objc func rewindButtonTapped() {
        if let lastImage = lastImage {
            animateImageChange(with: lastImage)
        }
    }
    
    @objc func settingsButtonTapped() {
        let settingsPage = SettingsPage()
        let hostingController = UIHostingController(rootView: settingsPage)

        present(hostingController, animated: true, completion: nil)
    }
    
}
