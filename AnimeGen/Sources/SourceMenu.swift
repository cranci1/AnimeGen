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
                ("AnimeWorld", .animeWorld, UIImage(named: "animeWorldIcon")!),
                ("GoGoAnime", .gogoanime, UIImage(named: "gogoanimeIcon")!),
                ("AnimeHeaven", .animeheaven, UIImage(named: "animeheavenIcon")!),
                ("AnimeFire", .animefire, UIImage(named: "animefireIcon")!),
                ("Kuramanime", .kuramanime, UIImage(named: "kuramanimeIcon")!),
                ("JKanime", .jkanime, UIImage(named: "jkanimeIcon")!),
                ("Anime3rb", .anime3rb, UIImage(named: "anime3rbIcon")!),
                ("Anix", .anix, UIImage(named: "anixIcon")!)
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
