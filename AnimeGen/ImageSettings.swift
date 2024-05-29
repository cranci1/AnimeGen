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
    
    private enum Keys {
        static let imageWidth = "ImageWidth"
        static let imageHeight = "ImageHeight"
    }
    
    private enum Defaults {
        static let imageWidth: Double = 0.9
        static let imageHeight: Double = 0.6
    }

    private let queue = DispatchQueue(label: "me.cranci.SettingsQueue", attributes: .concurrent)

    var imageWidth: Double {
        get {
            return queue.sync {
                defaults.double(forKey: Keys.imageWidth)
            }
        }
        set {
            queue.async(flags: .barrier) {
                self.defaults.set(newValue, forKey: Keys.imageWidth)
            }
        }
    }

    var imageHeight: Double {
        get {
            return queue.sync {
                defaults.double(forKey: Keys.imageHeight)
            }
        }
        set {
            queue.async(flags: .barrier) {
                self.defaults.set(newValue, forKey: Keys.imageHeight)
            }
        }
    }

    private init() {
        initializeDefaultValues()
    }

    private func initializeDefaultValues() {
        queue.async(flags: .barrier) {
            if self.defaults.object(forKey: Keys.imageWidth) == nil {
                self.defaults.set(Defaults.imageWidth, forKey: Keys.imageWidth)
            }
            if self.defaults.object(forKey: Keys.imageHeight) == nil {
                self.defaults.set(Defaults.imageHeight, forKey: Keys.imageHeight)
            }
        }
    }
}
