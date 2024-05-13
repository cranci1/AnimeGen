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
    @IBOutlet weak var DisplayHmtai: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // DevloperAlerts.isOn = UserDefaults.standard.bool(forKey: "enableDeveloperAlert")
        DisplayHmtai.isOn = UserDefaults.standard.bool(forKey: "enabledHmtaiAPI")
        
    }
    
    // @IBAction func switchDeveloperAlert(_ sender: UISwitch) {
    //    UserDefaults.standard.set(sender.isOn, forKey: "enableDeveloperAlert")
    // }
    
    @IBAction func switchHmtaiAPI(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        UserDefaults.standard.set(isEnabled, forKey: "enabledHmtaiAPI")
        NotificationCenter.default.post(name: Notification.Name("EnabledHmtaiAPI"), object: nil, userInfo: ["enabledHmtaiAPI": isEnabled])
    }
    
    @IBAction func waifuit(_ sender: UITapGestureRecognizer) {
        if let navigationController = self.navigationController,
           !(navigationController.topViewController is UIHostingController<waifuitView>) {
            let swiftUIView = waifuitView()
            navigationController.pushViewController(UIHostingController(rootView: swiftUIView), animated: true)
        }
    }

    @IBAction func hmtaipage(_ sender: UITapGestureRecognizer) {
        if let navigationController = self.navigationController,
           !(navigationController.topViewController is UIHostingController<HmtaiView>) {
            let swiftUIView = HmtaiView()
            navigationController.pushViewController(UIHostingController(rootView: swiftUIView), animated: true)
        }
    }
    
}

