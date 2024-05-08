//
//  FeaturesApp.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

class FeaturesApp: UITableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var Animations: UISwitch!
    @IBOutlet weak var Gradient: UISwitch!
    @IBOutlet weak var Gestures: UISwitch!
    @IBOutlet weak var ActivityLabel: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Animations.isOn = UserDefaults.standard.bool(forKey: "enableAnimations")
        Gradient.isOn = UserDefaults.standard.bool(forKey: "enablegradient")
        Gestures.isOn = UserDefaults.standard.bool(forKey: "enableGestures")
        ActivityLabel.isOn = UserDefaults.standard.bool(forKey: "enableTime")
    }
    
    @IBAction func switchAnimations(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableAnimations")
    }
    
    @IBAction func switchGradient(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        UserDefaults.standard.set(isEnabled, forKey: "enablegradient")
        NotificationCenter.default.post(name: Notification.Name("EnableGradient"), object: nil, userInfo: ["enablegradient": isEnabled])
    }
    
    @IBAction func switchTime(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        UserDefaults.standard.set(isEnabled, forKey: "enableTime")
        NotificationCenter.default.post(name: Notification.Name("EnableTime"), object: nil, userInfo: ["enableTime": isEnabled])
    }
    
    @IBAction func switctchGestures(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        UserDefaults.standard.set(isEnabled, forKey: "enableGestures")
        NotificationCenter.default.post(name: Notification.Name("EnableGestures"), object: nil, userInfo: ["enableGestures": isEnabled])
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        UserDefaults.standard.set(selectedIndex, forKey: "selectedIndex")
        
        let isEnabledLightMode = selectedIndex == 1
        UserDefaults.standard.set(isEnabledLightMode, forKey: "enabledLightMode")
        
        NotificationCenter.default.post(name: Notification.Name("EnabledLightMode"), object: nil, userInfo: ["enabledLightMode": isEnabledLightMode])
    }
}
