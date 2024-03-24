//
//  History.swift
//  AnimeGen
//
//  Created by Francesco on 24/03/24.
//

import UIKit
import SwiftUI
import Photos

extension ViewController {
    
    @objc func historyButtonTapped() {
        let history = HistoryView()
        let hostingController = UIHostingController(rootView: history)

        present(hostingController, animated: true, completion: nil)
    }
    
    func addToHistory(image: UIImage) {
        ImageHistory.addImage(image)
    }

}
