//
//  FeaturesApp.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

class FeaturesApp: UITableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var stepperWidth: UIStepper!
    @IBOutlet weak var stepperHeight: UIStepper!
    
    @IBOutlet weak var Animations: UISwitch!
    @IBOutlet weak var Gradient: UISwitch!
    @IBOutlet weak var Gestures: UISwitch!
    @IBOutlet weak var ActivityLabel: UISwitch!
    @IBOutlet weak var Buttons: UISwitch!
    
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepperWidth.value = Settings.shared.imageWidth
        stepperHeight.value = Settings.shared.imageHeight

        stepperWidth.minimumValue = 0.1
        stepperWidth.maximumValue = 1.0

        stepperHeight.minimumValue = 0.1
        stepperHeight.maximumValue = 1.0

        stepperWidth.addTarget(self, action: #selector(widthStepperChangeds(_:)), for: .valueChanged)
        stepperHeight.addTarget(self, action: #selector(heightStepperChangeds(_:)), for: .valueChanged)
        
        Animations.isOn = UserDefaults.standard.bool(forKey: "enableAnimations")
        Gradient.isOn = UserDefaults.standard.bool(forKey: "enablegradient")
        Gestures.isOn = UserDefaults.standard.bool(forKey: "enableGestures")
        ActivityLabel.isOn = UserDefaults.standard.bool(forKey: "enableTime")
        Buttons.isOn = UserDefaults.standard.bool(forKey: "enableButtons")
        
        updateWidthLabel()
        updateHeightLabel()
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
    
    @IBAction func switctchButtons(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableButtons")
    }
    
    @IBAction func widthStepperChangeds(_ sender: UIStepper) {
        Settings.shared.imageWidth = sender.value
        updateWidthLabel()
        print("New imageWidth: \(Settings.shared.imageWidth)")
    }

    @IBAction func heightStepperChangeds(_ sender: UIStepper) {
        Settings.shared.imageHeight = sender.value
        updateHeightLabel()
        print("New imageHeight: \(Settings.shared.imageHeight)")
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        UserDefaults.standard.set(selectedIndex, forKey: "selectedIndex")
        
        let isEnabledLightMode = selectedIndex == 1
        UserDefaults.standard.set(isEnabledLightMode, forKey: "enabledLightMode")
        
        NotificationCenter.default.post(name: Notification.Name("EnabledLightMode"), object: nil, userInfo: ["enabledLightMode": isEnabledLightMode])
    }
    
    func updateWidthLabel() {
        widthLabel.text = String(format: "Images Width: %.2f", Settings.shared.imageWidth)
    }
    
    func updateHeightLabel() {
        heightLabel.text = String(format: "Images Height: %.2f", Settings.shared.imageHeight)
    }
}
