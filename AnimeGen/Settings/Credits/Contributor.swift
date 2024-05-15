//
//  Contributor.swift
//  AnimeGen
//
//  Created by cranci on 15/05/24.
//

import UIKit

class ContributorsCredits: UITableViewController {
        
    // URLs
    let Max = "https://github.com/MaximilianGT500"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
        
    @IBAction func Max(_ sender: UITapGestureRecognizer) {
        openURL(Max)
    }
}
