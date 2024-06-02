//
//  AppPref.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

class AppPref: UITableViewController {
    
    @IBOutlet weak var APIDefa: UIButton!
    
    var isPresentingActionSheet = false
    var selectedChoiceIndex = 0
    let choices = ["waifu.im", "pic.re", "waifu.pics", "waifu.it", "nekos.best", "Nekos api", "nekos.moe", "NekoBot", "n-sfw.com", "Purr", "nekos.life"]
    
    @IBOutlet weak var LoadImageSwitch: UISwitch!
    @IBOutlet weak var DisplayTags: UISwitch!
    @IBOutlet weak var TagsHide: UISwitch!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedChoiceIndex = UserDefaults.standard.integer(forKey: "SelectedChoiceIndex")
        LoadImageSwitch.isOn = UserDefaults.standard.bool(forKey: "enableImageStartup")
        DisplayTags.isOn = UserDefaults.standard.bool(forKey: "enableTags")
        TagsHide.isOn = UserDefaults.standard.bool(forKey: "enableTagsHide")
        
        updateButtonTitle()
    }
    
    @IBAction func switchImageStartup(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableImageStartup")
    }
    
    @IBAction func switchTags(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableTags")
    }
    
    
    @IBAction func switchTagsHide(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        UserDefaults.standard.set(isEnabled, forKey: "enableTagsHide")
        NotificationCenter.default.post(name: Notification.Name("EnableTagsHide"), object: nil, userInfo: ["enableTagsHide": isEnabled])
    }
    
    @IBAction func presentActionSheet(_ sender: UIButton) {
         isPresentingActionSheet = true
         presentChoicesActionSheet()
     }
     
     func presentChoicesActionSheet() {
         let actionSheet = UIAlertController(title: "Choose Default API", message: nil, preferredStyle: .actionSheet)
         
         for (index, choice) in choices.enumerated() {
             actionSheet.addAction(UIAlertAction(title: choice, style: .default, handler: { _ in
                 self.updateSelectedChoiceIndex(index)
             }))
         }
         
         actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         
         present(actionSheet, animated: true, completion: nil)
     }
     
     func updateSelectedChoiceIndex(_ index: Int) {
         selectedChoiceIndex = index
         updateButtonTitle()
         UserDefaults.standard.set(selectedChoiceIndex, forKey: "SelectedChoiceIndex")
         NotificationCenter.default.post(name: Notification.Name("SelectedChoiceChanged"), object: selectedChoiceIndex)
     }
     
     func updateButtonTitle() {
         let selectedChoice = choices[selectedChoiceIndex]
         APIDefa.setTitle(selectedChoice, for: .normal)
     }
}
