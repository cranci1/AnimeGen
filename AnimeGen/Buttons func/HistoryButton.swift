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
        let history = HistoryView()
        let hostingController = UIHostingController(rootView: history)

        present(hostingController, animated: true, completion: nil)
    }
    
    func addToHistory(image: UIImage) {
        if HistoryTrue {
            ImageHistory.addImage(image)
        }
    }

}

