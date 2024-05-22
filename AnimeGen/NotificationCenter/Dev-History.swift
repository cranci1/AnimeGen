//
//  Dev-History.swift
//  AnimeGen
//
//  Created by cranci on 08/05/24.
//

import UIKit

extension ViewController {
    
    @objc func handleHmtaiShowcase(_ notification: Notification) {
        handleNotification(notification, key: "enableDevAPIs") { isEnabled in
            self.developerAPIs = isEnabled
        }
    }
    
    @objc func handleHsistory(_ notification: Notification) {
        handleNotification(notification, key: "enableHistory") { isEnabled in
            self.HistoryTrue = isEnabled
        }
    }
}
