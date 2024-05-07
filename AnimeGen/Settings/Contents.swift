//
//  Contents.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

class Contents: UITableViewController {
    
    @IBOutlet weak var Contents: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        Contents.isOn = UserDefaults.standard.bool(forKey: "enableExplictiCont")
        
    }

    @IBAction func switchContent(_ sender: UISwitch) {     
        UserDefaults.standard.set(sender.isOn, forKey: "enableExplictiCont")
    }
}

