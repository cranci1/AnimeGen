//
//  SourceMenu.swift
//  AnimeLounge
//
//  Created by Francesco on 05/07/24.
//

import UIKit

class SourceMenu {
    static weak var delegate: SourceSelectionDelegate?

    static func showSourceSelector(from viewController: UIViewController, sourceView: UIView?) {
        DispatchQueue.main.async {
            let sources: [(title: String, source: MediaSource, image: UIImage)] = [
                ("AnimeWorld", .animeWorld, UIImage(named: "AnimeWorld")!),
                ("GoGoAnime", .gogoanime, UIImage(named: "GoGoAnime")!),
                ("AnimeHeaven", .animeheaven, UIImage(named: "AnimeHeaven")!),
                ("AnimeFire", .animefire, UIImage(named: "AnimeFire")!),
                ("Kuramanime", .kuramanime, UIImage(named: "Kuramanime")!),
                ("JKanime", .jkanime, UIImage(named: "JKanime")!),
                ("Anime3rb", .anime3rb, UIImage(named: "Anime3rb")!),
                ("Anix", .anix, UIImage(named: "Anix")!)
            ]
            
            let alertController = UIAlertController(title: "Select Source", message: "Choose your preferred source for AnimeLounge.", preferredStyle: .actionSheet)
            
            for (title, source, image) in sources {
                let action = UIAlertAction(title: title, style: .default) { _ in
                    UserDefaults.standard.selectedMediaSource = source
                    delegate?.didSelectNewSource()
                }
                action.setValue(image.withRenderingMode(.alwaysOriginal), forKey: "image")
                alertController.addAction(action)
            }
            
            if let popoverController = alertController.popoverPresentationController, let sourceView = sourceView {
                popoverController.sourceView = sourceView
                popoverController.sourceRect = sourceView.bounds
            }
            
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}

protocol SourceSelectionDelegate: AnyObject {
    func didSelectNewSource()
}
