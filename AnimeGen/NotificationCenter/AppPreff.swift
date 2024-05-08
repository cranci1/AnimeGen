//
//  AppPref.swift
//  AnimeGen
//
//  Created by cranci on 08/05/24.
//

import UIKit

extension ViewController {
    
    @objc func handleGradient(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let isEnabled = userInfo["enablegradient"] as? Bool else {
            return
        }
        self.gradient = isEnabled
    }
    
    @objc func handleTime(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let isEnabled = userInfo["enableTime"] as? Bool else {
            return
        }
        self.activity = isEnabled
    }
    
    @objc func handleGestures(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let isEnabled = userInfo["enableGestures"] as? Bool else {
            return
        }
        self.gestures = isEnabled
    }
    
    @objc func handleLightMode(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let isEnabled = userInfo["enabledLightMode"] as? Bool else {
            return
        }
        self.lightmode = isEnabled
    }
    
}
