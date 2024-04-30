//
//  ImageHistory.swift
//  AnimeGen
//
//  Created by cranci on 24/03/24.
//

import Foundation
import UIKit

struct ImageHistory {
    static var images: [UIImage] {
        get {
            if UserDefaults.standard.bool(forKey: "enableHistoryOvertime") {
                if let data = UserDefaults.standard.data(forKey: "imageHistory") {
                    do {
                        let images = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, UIImage.self], from: data) as? [UIImage]
                        return images ?? []
                    } catch {
                        print("Error unarchiving image history:", error)
                        return []
                    }
                } else {
                    return []
                }
            } else {
                return storedImages
            }
        }
        set {
            if UserDefaults.standard.bool(forKey: "enableHistoryOvertime") {
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: true)
                    UserDefaults.standard.set(data, forKey: "imageHistory")
                } catch {
                    print("Error archiving image history:", error)
                }
            } else {
                storedImages = newValue
            }
        }
    }
    
    private static var storedImages: [UIImage] = []
    
    static func addImage(_ image: UIImage) {
        if UserDefaults.standard.bool(forKey: "enableHistoryOvertime") {
            var currentImages = images
            currentImages.append(image)
            images = currentImages
        } else {
            storedImages.append(image)
        }
    }
}
