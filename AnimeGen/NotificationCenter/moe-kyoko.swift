//
//  moe-kyoko.swift
//  AnimeGen
//
//  Created by cranci on 08/05/24.
//

import UIKit

extension ViewController {
    
    @objc func handleMoeTags(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let isEnabled = userInfo["enableMoeTags"] as? Bool else {
            return
        }
        self.moetags = isEnabled
    }
    
    @objc func handleKyokoBanner(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let isEnabled = userInfo["enableKyokobanner"] as? Bool else {
            return
        }
        self.kyokobanner = isEnabled
    }
    
}
