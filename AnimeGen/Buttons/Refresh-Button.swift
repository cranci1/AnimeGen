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
            lastImage = imageView.image
            loadImageAndTagsFromPicRe()
        case "waifu.im":
            lastImage = imageView.image
            loadImageAndTagsFromWaifuIm()
        case "nekos.best":
            lastImage = imageView.image
            loadImageAndTagsFromNekosBest()
        case "waifu.pics":
            lastImage = imageView.image
            loadImageFromWaifuPics()
        case "Hmtai":
            lastImage = imageView.image
            startHmtaiLoader()
        case "Nekos api":
            lastImage = imageView.image
            loadImageAndTagsFromNekosapi()
        case "nekos.moe":
            lastImage = imageView.image
            loadImageAndTagsFromNekosMoe()
        case "kyoko":
            lastImage = imageView.image
            loadImageAndTagsFromKyoko()
        case "Purr":
            lastImage = imageView.image
            loadImageAndTagsFromPurr()
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
