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
    
    var imageWidth: Double = 100.0
    var imageHeight: Double = 60.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StepperWidth.addTarget(self, action: #selector(widthStepperChanged(_:)), for: .valueChanged)
        StepperHeight.addTarget(self, action: #selector(heightStepperChanged(_:)), for: .valueChanged)
      }
    
    @IBAction func widthStepperChanged(_ sender: UIStepper) {
        imageWidth = sender.value
    }
    
    @IBAction func heightStepperChanged(_ sender: UIStepper) {
        imageHeight = sender.value
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
