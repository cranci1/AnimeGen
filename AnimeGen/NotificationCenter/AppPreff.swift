//
//  AppPref.swift
//  AnimeGen
//
//  Created by cranci on 08/05/24.
//

import UIKit

extension ViewController {
    
    @objc func handleGradient(_ notification: Notification) {
        handleNotification(notification, key: "enablegradient") { isEnabled in
            self.gradient = isEnabled
        }
    }
    
    @objc func handleTime(_ notification: Notification) {
        handleNotification(notification, key: "enableTime") { isEnabled in
            self.activity = isEnabled
        }
    }
    
    @objc func handleGestures(_ notification: Notification) {
        handleNotification(notification, key: "enableGestures") { isEnabled in
            self.gestures = isEnabled
        }
    }
    
    @objc func handleLightMode(_ notification: Notification) {
        handleNotification(notification, key: "enabledLightMode") { isEnabled in
            self.lightmode = isEnabled
        }
    }
}
