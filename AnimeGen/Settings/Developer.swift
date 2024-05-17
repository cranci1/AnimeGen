//
//  Developer.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit
import SwiftUI

class DeveloperPref: UITableViewController {
    
    // @IBOutlet weak var DevloperAlerts: UISwitch!
    @IBOutlet weak var DisplayAPisStuff: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // DevloperAlerts.isOn = UserDefaults.standard.bool(forKey: "enableDeveloperAlert")
        DisplayAPisStuff.isOn = UserDefaults.standard.bool(forKey: "enableDevAPIs")
        
    }
    
    // @IBAction func switchDeveloperAlert(_ sender: UISwitch) {
    //    UserDefaults.standard.set(sender.isOn, forKey: "enableDeveloperAlert")
    // }
    
    @IBAction func switchHmtaiAPI(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        UserDefaults.standard.set(isEnabled, forKey: "enableDevAPIs")
        NotificationCenter.default.post(name: Notification.Name("EnableDevAPIs"), object: nil, userInfo: ["enableDevAPIs": isEnabled])
    }
    
    @IBAction func waifuit(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let navigationController = self.navigationController else { return }
            if !(navigationController.topViewController is UIHostingController<waifuitView>) {
                let swiftUIView = waifuitView()
                let hostingController = UIHostingController(rootView: swiftUIView)
                navigationController.pushViewController(hostingController, animated: true)
            }
        }
    }

    @IBAction func hmtaipage(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let navigationController = self.navigationController else { return }
            if !(navigationController.topViewController is UIHostingController<HmtaiView>) {
                let swiftUIView = HmtaiView()
                let hostingController = UIHostingController(rootView: swiftUIView)
                navigationController.pushViewController(hostingController, animated: true)
            }
        }
    }
    
}

