//
//  HistoryButton.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit
import SwiftUI

extension ViewController {
    
    @IBAction func historyButtonTapped() {
        let historyView = HistoryView()
        let hostingController = UIHostingController(rootView: historyView)
        present(hostingController, animated: true, completion: nil)
    }
    
    func addToHistory(image: UIImage) {
        guard HistoryTrue else {
            print("History is disabled.")
            return
        }
        ImageHistory.addImage(image)
    }
}
