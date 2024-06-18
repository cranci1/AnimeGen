//
//  ImageGenerationSettings.swift
//  AnimeGen
//
//  Created by Francesco on 17/06/24.
//

import UIKit

class ImageGenerationSettings: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openTagSelectionPics(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedAPI = "waifu.pics"
        
        if let tagSelectionVC = storyboard.instantiateViewController(identifier: "TagSelectionViewController") as? TagSelectionViewController {
            tagSelectionVC.selectedAPI = selectedAPI
            self.navigationController?.pushViewController(tagSelectionVC, animated: true)
        }
    }
    
    @IBAction func openTagSelectionBest(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedAPI = "nekos.best"
        
        if let tagSelectionVC = storyboard.instantiateViewController(identifier: "TagSelectionViewController") as? TagSelectionViewController {
            tagSelectionVC.selectedAPI = selectedAPI
            self.navigationController?.pushViewController(tagSelectionVC, animated: true)
        }
    }
    
    @IBAction func openTagSelectionBot(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedAPI = "nekosBot"
        
        if let tagSelectionVC = storyboard.instantiateViewController(identifier: "TagSelectionViewController") as? TagSelectionViewController {
            tagSelectionVC.selectedAPI = selectedAPI
            self.navigationController?.pushViewController(tagSelectionVC, animated: true)
        }
    }
    
    @IBAction func openTagSelectionNSFWCOm(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedAPI = "n-sfw.com"
        
        if let tagSelectionVC = storyboard.instantiateViewController(identifier: "TagSelectionViewController") as? TagSelectionViewController {
            tagSelectionVC.selectedAPI = selectedAPI
            self.navigationController?.pushViewController(tagSelectionVC, animated: true)
        }
    }
    
    @IBAction func openTagSelectionPurr(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedAPI = "Purr"
        
        if let tagSelectionVC = storyboard.instantiateViewController(identifier: "TagSelectionViewController") as? TagSelectionViewController {
            tagSelectionVC.selectedAPI = selectedAPI
            self.navigationController?.pushViewController(tagSelectionVC, animated: true)
        }
    }
    
    @IBAction func openTagSelectionLife(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedAPI = "nekos.life"
        
        if let tagSelectionVC = storyboard.instantiateViewController(identifier: "TagSelectionViewController") as? TagSelectionViewController {
            tagSelectionVC.selectedAPI = selectedAPI
            self.navigationController?.pushViewController(tagSelectionVC, animated: true)
        }
    }
    
    @IBAction func openTagSelectionIt(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedAPI = "waifu.it"
        
        if let tagSelectionVC = storyboard.instantiateViewController(identifier: "TagSelectionViewController") as? TagSelectionViewController {
            tagSelectionVC.selectedAPI = selectedAPI
            self.navigationController?.pushViewController(tagSelectionVC, animated: true)
        }
    }
    
    @IBAction func openTagSelectionKyoko(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedAPI = "Kyoko"
        
        if let tagSelectionVC = storyboard.instantiateViewController(identifier: "TagSelectionViewController") as? TagSelectionViewController {
            tagSelectionVC.selectedAPI = selectedAPI
            self.navigationController?.pushViewController(tagSelectionVC, animated: true)
        }
    }
    
    @IBAction func openTagSelectionHmtai(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedAPI = "Hmtai"
        
        if let tagSelectionVC = storyboard.instantiateViewController(identifier: "TagSelectionViewController") as? TagSelectionViewController {
            tagSelectionVC.selectedAPI = selectedAPI
            self.navigationController?.pushViewController(tagSelectionVC, animated: true)
        }
    }
}
