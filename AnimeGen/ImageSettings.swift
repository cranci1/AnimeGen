//
//  ImageWidhts.swift
//  AnimeGen
//
//  Created by cranci on 24/05/24.
//

import Foundation

final class Settings {
    static let shared = Settings()

    private let defaults = UserDefaults.standard

    var imageWidth: Double {
        get { return defaults.double(forKey: "ImageWidth") }
        set { defaults.set(newValue, forKey: "ImageWidth") }
    }

    var imageHeight: Double {
        get { return defaults.double(forKey: "ImageHeight") }
        set { defaults.set(newValue, forKey: "ImageHeight") }
    }

    private init() {
        loadSavedValues()
    }

    private func loadSavedValues() {
        imageWidth = defaults.double(forKey: "ImageWidth")
        imageHeight = defaults.double(forKey: "ImageHeight")
    }
}

