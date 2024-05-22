//
//  moe-kyoko.swift
//  AnimeGen
//
//  Created by cranci on 08/05/24.
//

import UIKit

extension ViewController {
    
    @objc func handleMoeTags(_ notification: Notification) {
        handleNotification(notification, key: "enableMoeTags") { isEnabled in
            self.moetags = isEnabled
        }
    }
    
    @objc func handleParentMode(_ notification: Notification) {
        handleNotification(notification, key: "parentsModeLoL") { isEnabled in
            self.parentsModeLoL = isEnabled
        }
    }
    
}
