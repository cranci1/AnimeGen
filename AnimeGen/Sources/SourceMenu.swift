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
            let sources: [(title: String, source: MediaSource)] = [
                ("AnimeWorld", .animeWorld),
                ("GoGoAnime", .gogoanime),
                ("AnimeHeaven", .animeheaven),
                ("AnimeFire", .animefire),
                ("Kuramanime", .kuramanime),
                ("JKanime", .jkanime),
                ("Anime3rb", .anime3rb),
                ("Anix", .anix)
            ]
            
            let alertController: UIAlertController
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                // Use popover style for iPad
                alertController = UIAlertController(title: "Select Source", message: "Choose your preferred source for AnimeLounge.", preferredStyle: .alert)
                
                let stackView = UIStackView()
                stackView.axis = .vertical
                stackView.spacing = 10
                stackView.distribution = .fillEqually
                
                for (title, source) in sources {
                    let button = UIButton(type: .system)
                    button.setTitle(title, for: .normal)
                    button.addTarget(self, action: #selector(sourceButtonTapped(_:)), for: .touchUpInside)
                    button.tag = sources.firstIndex(where: { $0.source == source }) ?? 0
                    setSourceImage(for: button, named: title)
                    stackView.addArrangedSubview(button)
                }
                
                let contentViewController = UIViewController()
                contentViewController.view = stackView
                contentViewController.preferredContentSize = CGSize(width: 250, height: CGFloat(sources.count) * 50)
                
                alertController.setValue(contentViewController, forKey: "contentViewController")
            } else {
                // Use action sheet style for iPhone
                alertController = UIAlertController(title: "Select Source", message: "Choose your preferred source for AnimeLounge.", preferredStyle: .actionSheet)
                
                for (title, source) in sources {
                    let action = UIAlertAction(title: title, style: .default) { _ in
                        UserDefaults.standard.set(source.rawValue, forKey: "selectedMediaSource")
                        delegate?.didSelectNewSource()
                    }
                    setSourceImage(for: action, named: title)
                    alertController.addAction(action)
                }
            }
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            if let popoverController = alertController.popoverPresentationController {
                if let sourceView = sourceView, sourceView.window != nil {
                    popoverController.sourceView = sourceView
                    popoverController.sourceRect = sourceView.bounds
                } else {
                    popoverController.sourceView = viewController.view
                    popoverController.sourceRect = viewController.view.bounds
                }
            }
            
            viewController.present(alertController, animated: true)
        }
    }
    
    @objc private static func sourceButtonTapped(_ sender: UIButton) {
        let sources: [MediaSource] = [.animeWorld, .gogoanime, .animeheaven, .animefire, .kuramanime, .jkanime, .anime3rb, .anix]
        guard sender.tag < sources.count else { return }
        let selectedSource = sources[sender.tag]
        UserDefaults.standard.set(selectedSource.rawValue, forKey: "selectedMediaSource")
        delegate?.didSelectNewSource()
        sender.superview?.superview?.superview?.superview?.removeFromSuperview()
        if let alertController = UIApplication.shared.windows.first?.rootViewController?.presentedViewController as? UIAlertController {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    private static func setSourceImage(for action: UIAlertAction, named imageName: String) {
        guard let originalImage = UIImage(named: imageName) else { return }
        let resizedImage = originalImage.resized(to: CGSize(width: 35, height: 35))
        action.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
    }
    
    private static func setSourceImage(for button: UIButton, named imageName: String) {
        guard let originalImage = UIImage(named: imageName) else { return }
        let resizedImage = originalImage.resized(to: CGSize(width: 35, height: 35))
        button.setImage(resizedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
    }
}

protocol SourceSelectionDelegate: AnyObject {
    func didSelectNewSource()
}
