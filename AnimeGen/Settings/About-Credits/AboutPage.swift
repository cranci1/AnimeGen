//
//  AboutPage.swift
//  AnimeGen
//
//  Created by cranci on 06/05/24.
//

import UIKit

class AboutPageViewController: UITableViewController {
    
    // Outlets for labels
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    
    // URLs
    let githubURL = "https://github.com/cranci1/AnimeGen/"
    let reportIssueURL = "https://github.com/cranci1/AnimeGen/issues"
    let reviewCodeURL = "https://github.com/cranci1/AnimeGen/tree/main"
    let hmtaiPrivacyURL = "https://github.com/cranci1/AnimeGen/blob/main/Privacy/Hmtai.md"
    let fullLicenseURL = "https://github.com/cranci1/AnimeGen/blob/main/LICENSE"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version: \(appVersion)"
        } else {
            versionLabel.text = "Version: N/A"
        }
        
        if let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            buildLabel.text = "Build: \(appBuild)"
        } else {
            buildLabel.text = "Build: N/A"
        }
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func githubTapped(_ sender: UITapGestureRecognizer) {
        openURL(githubURL)
    }
    
    @IBAction func reportIssueTapped(_ sender: UITapGestureRecognizer) {
        openURL(reportIssueURL)
    }
    
    @IBAction func reviewCodeTapped(_ sender: UITapGestureRecognizer) {
        openURL(reviewCodeURL)
    }
    
    @IBAction func hmtaiPrivacyTapped(_ sender: UITapGestureRecognizer) {
        openURL(hmtaiPrivacyURL)
    }
    
    @IBAction func fullLicenseTapped(_ sender: UITapGestureRecognizer) {
        openURL(fullLicenseURL)
    }
}
