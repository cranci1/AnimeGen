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
            return
        }

        switch title {
        case "pic.re":
            loadImageFromPicRe()
            showPopUpBanner(message: "This API is not supported on your iOS version!", viewController: self) {
                if #available(iOS 14.0, *) {
                    // nothing here cuz ios 14+ 💪
                } else {
                    self.apiButton.setTitle("waifu.im", for: .normal)
                    self.loadImageFromWaifuIm()
                }
            }
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
            showPopUpBanner(message: "This API is not supported on your iOS version!", viewController: self) {
                if #available(iOS 14.0, *) {
                    // nothing here cuz ios 14+ 💪
                } else {
                    self.apiButton.setTitle("waifu.im", for: .normal)
                    self.loadImageFromWaifuIm()
                }
            }
        case "nekos.moe":
            loadImageFromNekosMoe()
        case "kyoko":
            loadImageFromKyoko()
        case "Purr":
            loadImageFromPurr()
        case "NekoBot":
            loadImageFromNekoBot()
        case "Hmtai":
            startHmtaiLoader()
        case "n-sfw api":
            loadImageFromNSFW()
        default:
            break
        }
    }

    @objc func apiButtonTapped() {
        let alertController = UIAlertController(title: "Select API", message: nil, preferredStyle: .actionSheet)
        
        var apiOptions: [String]
        
        if #available(iOS 14.0, *) {
            if hmtaiON {
                apiOptions = ["Purr", "n-sfw api", "NekoBot", "nekos.moe", "Nekos api", "nekos.best", "Hmtai", "waifu.it", "waifu.pics", "waifu.im", "pic.re"]
            } else {
                apiOptions = ["Purr", "n-sfw api", "NekoBot", "nekos.moe", "Nekos api", "nekos.best", "waifu.it", "waifu.pics", "waifu.im", "pic.re"]
            }
        } else {
            if hmtaiON {
                apiOptions = ["Purr", "n-sfw api", "NekoBot", "nekos.moe", "nekos.best", "Hmtai", "waifu.it", "waifu.pics", "waifu.im"]
            } else {
                apiOptions = ["Purr", "n-sfw api", "NekoBot", "nekos.moe", "nekos.best", "waifu.it", "waifu.pics", "waifu.im"]
            }
        }
        
        for option in apiOptions {
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
