//
//  Historyy.swift
//  AnimeGen
//
//  Created by cranci on 06/05/24.
//

import UIKit

class History: UITableViewController {
    
    @IBOutlet weak var historySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        historySwitch.isOn = UserDefaults.standard.bool(forKey: "enableHistory")
    }

    @IBAction func switchHistory(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        UserDefaults.standard.set(isEnabled, forKey: "enableHistory")
        NotificationCenter.default.post(name: Notification.Name("EnableHistory"), object: nil, userInfo: ["enableHistory": isEnabled])
    }

    @IBAction func clearButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Clear History", message: "Are you sure you want to clear the history?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            ImageHistory.images.removeAll()
        }))
        
        present(alertController, animated: true, completion: nil)
    }


}
