//
//  FrameWorksCredits.swift
//  AnimeGen
//
//  Created by cranci on 15/05/24.
//

import UIKit

class FrameWorksCredits: UITableViewController {
        
    // URLs
    let SDweb = "https://github.com/SDWebImage/SDWebImage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
        
    @IBAction func SDweb(_ sender: UITapGestureRecognizer) {
        openURL(SDweb)
    }
    
}
