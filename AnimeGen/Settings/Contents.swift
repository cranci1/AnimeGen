//
//  Contents.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

class Contents: UITableViewController {
    
    @IBOutlet weak var Contents: UISwitch!
    @IBOutlet weak var ContentsRemoval: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        Contents.isOn = UserDefaults.standard.bool(forKey: "disableExplicitContent")
        ContentsRemoval.isOn = UserDefaults.standard.bool(forKey: "enableExplicitContent")
        
    }

    @IBAction func switchContent(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableExplicitContent")
    }
    
    @IBAction func switchContentRemove(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "disableExplicitContent")
    }

}

