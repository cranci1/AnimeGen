//
//  content-tags.swift
//  AnimeGen
//
//  Created by cranci on 08/05/24.
//

import UIKit

extension ViewController {
    
    @objc func handleParentMode(_ notification: Notification) {
        handleNotification(notification, key: "parentsModeLoL") { isEnabled in
            self.parentsModeLoL = isEnabled
        }
    }
    
    @objc func handleTags(_ notification: Notification) {
        handleNotification(notification, key: "enableTagsHide") { isEnabled in
            self.TagsHide = isEnabled
        }
    }
}
