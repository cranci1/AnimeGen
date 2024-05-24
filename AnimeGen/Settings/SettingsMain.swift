//
//  SettingsMain.swift
//  AnimeGen
//
//  Created by cranci on 07/05/24.
//

import UIKit
import SwiftUI

class SettingsMain: UITableViewController {

    @IBOutlet weak var stepperWidth: UIStepper!
    @IBOutlet weak var stepperHeight: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()

        stepperWidth.value = Settings.shared.imageWidth
        stepperHeight.value = Settings.shared.imageHeight

        stepperWidth.minimumValue = 0.1
        stepperWidth.maximumValue = 1.0

        stepperHeight.minimumValue = 0.1
        stepperHeight.maximumValue = 1.0

        stepperWidth.addTarget(self, action: #selector(widthStepperChanged(_:)), for: .valueChanged)
        stepperHeight.addTarget(self, action: #selector(heightStepperChanged(_:)), for: .valueChanged)
    }

    @IBAction func widthStepperChanged(_ sender: UIStepper) {
        Settings.shared.imageWidth = sender.value
        print("New imageWidth: \(Settings.shared.imageWidth)")
    }

    @IBAction func heightStepperChanged(_ sender: UIStepper) {
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
