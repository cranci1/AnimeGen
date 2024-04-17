//
//  Refresh-Button.swift
//  AnimeGen
//
//  Created by cranci on 20/03/24.
//

import UIKit

extension ViewController {
    
    @objc func refreshButtonTapped() {
        guard let title = apiButton.title(for: .normal) else {
            return
        }

        switch title {
        case "pic.re":
            showPopUpBanner(message: "This API is not supported on your iOS version!", viewController: self) {
                if #available(iOS 14.0, *) {
                    // nothing here cuz ios 14+ 💪
                } else {
                    self.apiButton.setTitle("waifu.im", for: .normal)
                    self.loadImageFromWaifuIm()
                }
            }
            lastImage = imageView.image
            loadImageFromPicRe()
        case "waifu.im":
            lastImage = imageView.image
            loadImageFromWaifuIm()
        case "nekos.best":
            lastImage = imageView.image
            loadImageFromNekosBest()
        case "waifu.pics":
            lastImage = imageView.image
            loadImageFromWaifuPics()
        case "Hmtai":
            lastImage = imageView.image
            startHmtaiLoader()
        case "Nekos api":
            showPopUpBanner(message: "This API is not supported on your iOS version!", viewController: self) {
                if #available(iOS 14.0, *) {
                    // nothing here cuz ios 14+ 💪
                } else {
                    self.apiButton.setTitle("waifu.im", for: .normal)
                    self.loadImageFromWaifuIm()
                }
            }
            lastImage = imageView.image
            loadImageFromNekosapi()
        case "nekos.moe":
            lastImage = imageView.image
            loadImageFromNekosMoe()
        case "kyoko":
            lastImage = imageView.image
            loadImageFromKyoko()
        case "Purr":
            lastImage = imageView.image
            loadImageFromPurr()
        default:
            break
        }
    }

    @objc func apiButtonTapped() {
        let alertController = UIAlertController(title: "Select API", message: nil, preferredStyle: .actionSheet)

        let apiOptions = ["Purr", "kyoko", "nekos.moe", "Nekos api", "Hmtai", "waifu.pics", "nekos.best", "waifu.im", "pic.re"]
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
