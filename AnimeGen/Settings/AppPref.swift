//
//  AppPref.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

class AppPref: UITableViewController {

    @IBOutlet weak var LoadImageSwitch: UISwitch!
    @IBOutlet weak var DisplayTags: UISwitch!
    @IBOutlet weak var DisplayNekosTags: UISwitch!
    @IBOutlet weak var KyokoNoteBanner: UISwitch!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadImageSwitch.isOn = UserDefaults.standard.bool(forKey: "enableImageStartup")
        DisplayTags.isOn = UserDefaults.standard.bool(forKey: "enableTags")
        DisplayNekosTags.isOn = UserDefaults.standard.bool(forKey: "enableMoeTags")
        KyokoNoteBanner.isOn = UserDefaults.standard.bool(forKey: "enableKyokobanner")
                
    }
    
    @IBAction func switchImageStartup(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableImageStartup")
    }
    
    @IBAction func switchTags(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableTags")
    }
    
    @IBAction func switchMoeTags(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        UserDefaults.standard.set(isEnabled, forKey: "enableMoeTags")
        NotificationCenter.default.post(name: Notification.Name("EnableMoeTagsChanged"), object: nil, userInfo: ["enableMoeTags": isEnabled])
    }
    
    @IBAction func switchKyokoBanner(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        UserDefaults.standard.set(isEnabled, forKey: "enableKyokobanner")
        NotificationCenter.default.post(name: Notification.Name("EnableKyokoBanner"), object: nil, userInfo: ["enableKyokobanner": isEnabled])
    }
            
}
