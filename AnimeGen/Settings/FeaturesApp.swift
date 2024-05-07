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
        
        let selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
        segmentedControl.selectedSegmentIndex = selectedIndex
        if UserDefaults.standard.value(forKey: "enabledLightMode") == nil {
            UserDefaults.standard.set(false, forKey: "enabledLightMode")
        }
        
    }
    
    @IBAction func switchAnimations(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableAnimations")
    }
    
    @IBAction func switchGradient(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enablegradient")
    }
    
    @IBAction func switchTime(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableTime")
    }
    
    @IBAction func switctchGestures(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableGestures")
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        UserDefaults.standard.set(selectedIndex, forKey: "selectedIndex")
        
        if selectedIndex == 1 {
            UserDefaults.standard.set(true, forKey: "enabledLightMode")
        } else {
            UserDefaults.standard.set(false, forKey: "enabledLightMode")
        }
    }
}
