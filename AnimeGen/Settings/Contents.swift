//
//  Contents.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

class Contents: UITableViewController {
    
    @IBOutlet weak var Contents: UISwitch!
    @IBOutlet weak var ParentMode: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        Contents.isOn = UserDefaults.standard.bool(forKey: "explicitContents")
        ParentMode.isOn = UserDefaults.standard.bool(forKey: "parentsModeLoL")
        
    }

    @IBAction func switchContent(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "explicitContents")
    }
    
    @IBAction func switchContentRemove(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        UserDefaults.standard.set(isEnabled, forKey: "parentsModeLoL")
        NotificationCenter.default.post(name: Notification.Name("ParentsModeLoL"), object: nil, userInfo: ["parentsModeLoL": isEnabled])
    }

}

