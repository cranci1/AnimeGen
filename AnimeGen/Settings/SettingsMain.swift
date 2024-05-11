//
//  SettingsMain.swift
//  AnimeGen
//
//  Created by Francesco on 07/05/24.
//

import UIKit
import SwiftUI

class SettingsMain: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func APIsStatus(_ sender: UITapGestureRecognizer) {
        if let navigationController = self.navigationController,
           !(navigationController.topViewController is UIHostingController<APIsSuppport>) {
            let swiftUIView = APIsSuppport()
            navigationController.pushViewController(UIHostingController(rootView: swiftUIView), animated: true)
        }
    }


}
