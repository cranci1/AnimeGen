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
    
    let choices = ["waifu.im", "pic.re", "waifu.pics", "nekos.best", "Nekos api", "nekos.moe", "NekoBot", "nekos.life", "n-sfw.com", "Purr"]
    let choiceIcons = ["waifu.im", "pic-re", "waifu.pics", "nekos.best", "nekosapi", "nekos.moe", "NekoBot", "nekos.life", "n-sfw", "Purr"]
    
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
        presentChoicesActionSheet(from: sender)
    }
     
    func presentChoicesActionSheet(from sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Default API", message: nil, preferredStyle: .actionSheet)
        
        for (index, choice) in choices.enumerated() {
            let action = UIAlertAction(title: choice, style: .default, handler: { _ in
                self.updateSelectedChoiceIndex(index)
            })
            if let icon = UIImage(named: choiceIcons[index]) {
                let resizedIcon = icon.resizedImage(to: CGSize(width: 35, height: 35))
                action.setValue(resizedIcon.withRenderingMode(.alwaysOriginal), forKey: "image")
            }
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
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

extension UIImage {
    func resizedImage(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
