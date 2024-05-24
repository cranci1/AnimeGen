//
//  SettingsMain.swift
//  AnimeGen
//
//  Created by cranci on 07/05/24.
//

import UIKit
import SwiftUI

class SettingsMain: UITableViewController {
    
    @IBOutlet weak var StepperWidth: UIStepper!
    @IBOutlet weak var StepperHeight: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize steppers with singleton values
        StepperWidth.value = Settings.shared.imageWidth
        StepperHeight.value = Settings.shared.imageHeight
        
        // Set minimum and maximum values if needed
        StepperWidth.minimumValue = 50.0
        StepperWidth.maximumValue = 300.0
        StepperHeight.minimumValue = 50.0
        StepperHeight.maximumValue = 300.0
        
        // Add target actions for steppers
        StepperWidth.addTarget(self, action: #selector(widthStepperChanged(_:)), for: .valueChanged)
        StepperHeight.addTarget(self, action: #selector(heightStepperChanged(_:)), for: .valueChanged)
    }
    
    @objc func widthStepperChanged(_ sender: UIStepper) {
        Settings.shared.imageWidth = sender.value
        print("New imageWidth: \(Settings.shared.imageWidth)")
    }
    
    @objc func heightStepperChanged(_ sender: UIStepper) {
        Settings.shared.imageHeight = sender.value
        print("New imageHeight: \(Settings.shared.imageHeight)")
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

class Settings {
    static let shared = Settings()
    
    var imageWidth: Double = 100.0
    var imageHeight: Double = 60.0
    
    private init() {}
}
