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
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let navigationController = self.navigationController else { return }
            if !(navigationController.topViewController is UIHostingController<APIsSuppport>) {
                let swiftUIView = APIsSuppport()
                let hostingController = UIHostingController(rootView: swiftUIView)
                navigationController.pushViewController(hostingController, animated: true)
            }
        }
    }
}
