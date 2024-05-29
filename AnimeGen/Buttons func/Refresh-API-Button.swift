//
//  Refresh-API-Button.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

extension ViewController {
    
    @IBAction func refreshButtonTapped() {
        guard let title = apiButton.title(for: .normal) else {
            print("API button has no title.")
            return
        }
        
        switch title {
        case "pic.re":
            loadImageFromPicRe()
            handleUnsupportedAPIBanner()
        case "waifu.im":
            loadImageFromWaifuIm()
        case "waifu.it":
            loadImageFromWaifuIt()
        case "nekos.best":
            loadImageFromNekosBest()
        case "waifu.pics":
            loadImageFromWaifuPics()
        case "Hmtai api":
            startHmtaiLoader()
        case "Nekos api":
            loadImageFromNekosapi()
            handleUnsupportedAPIBanner()
        case "nekos.moe":
            loadImageFromNekosMoe()
        case "kyoko":
            loadImageFromKyoko()
        case "Purr":
            loadImageFromPurr()
        case "NekoBot":
            loadImageFromNekoBot()
        case "n-sfw.com":
            loadImageFromNSFW()
        case "nekos.life":
            loadImageFromNekosLife()
        default:
            print("Unknown API: \(title)")
        }
    }

    private func handleUnsupportedAPIBanner() {
        showPopUpBanner(message: "This API is not supported on your iOS version!", viewController: self) {
            if #available(iOS 14.0, *) {
                //nothing cuz iOS 14 is strong frfr
            } else {
                self.apiButton.setTitle("waifu.im", for: .normal)
                self.loadImageFromWaifuIm()
            }
        }
    }

    @objc func apiButtonTapped() {
        let alertController = UIAlertController(title: "Select API", message: nil, preferredStyle: .actionSheet)
        
        let apiOptions: [String]
        
        if #available(iOS 14.0, *) {
            apiOptions = developerAPIs ? ["Purr", "kyoko", "n-sfw.com", "nekos.life", "NekoBot", "nekos.moe", "Nekos api", "nekos.best", "Hmtai api", "waifu.it", "waifu.pics", "waifu.im", "pic.re"]
                                       : ["Purr", "n-sfw.com", "nekos.life", "NekoBot", "nekos.moe", "Nekos api", "nekos.best", "waifu.pics", "waifu.im", "pic.re"]
        } else {
            apiOptions = developerAPIs ? ["Purr", "kyoko", "n-sfw.com", "nekos.life", "NekoBot", "nekos.moe", "nekos.best", "Hmtai api", "waifu.it", "waifu.pics", "waifu.im"]
                                       : ["Purr", "n-sfw.com", "nekos.life", "NekoBot", "nekos.moe", "nekos.best", "waifu.pics", "waifu.im"]
        }
        
        apiOptions.forEach { option in
            let action = UIAlertAction(title: option, style: .default) { _ in
                self.apiButton.setTitle(option, for: .normal)
                self.loadImageAndTagsFromSelectedAPI()
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = apiButton
        alertController.popoverPresentationController?.sourceRect = apiButton.bounds
        present(alertController, animated: true, completion: nil)
    }
}
