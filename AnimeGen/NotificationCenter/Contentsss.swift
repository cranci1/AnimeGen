//
//  Contentsss.swift
//  AnimeGen
//
//  Created by Francesco on 21/05/24.
//

import UIKit

extension ViewController {
    
    @objc func handleParentMode(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let isEnabled = userInfo["ParentsModeLoL"] as? Bool else {
            return
        }
        self.parentsModeLoL = isEnabled
    }
}
