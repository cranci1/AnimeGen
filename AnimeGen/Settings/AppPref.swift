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
    var selectedChoiceIndex = 1
    
    let choices = ["Purr", "n-sfw.com", "nekos.life", "NekoBot", "nekos.moe", "Nekos api", "nekos.best", "waifu.pics", "waifu.im", "pic.re"]
    let choiceIcons = ["Purr", "n-sfw", "nekos.life", "NekoBot", "nekos.moe", "nekosapi", "nekos.best", "waifu.pics", "waifu.im", "pic-re"]
    
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
            let action = UIAlertAction(title: choice, style: .default, handler: { _ in
                self.updateSelectedChoiceIndex(index)
            })
            if let icon = UIImage(named: choiceIcons[index]) {
                let resizedIcon = icon.resized(to: CGSize(width: 35, height: 35))
                action.setValue(resizedIcon.withRenderingMode(.alwaysOriginal), forKey: "image")
            }
            actionSheet.addAction(action)
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
