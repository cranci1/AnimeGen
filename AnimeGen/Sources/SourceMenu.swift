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
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                showPopoverMenu(from: viewController, sourceView: sourceView, sources: sources)
            } else {
                showActionSheet(from: viewController, sourceView: sourceView, sources: sources)
            }
        }
    }
    
    private static func showActionSheet(from viewController: UIViewController, sourceView: UIView?, sources: [(title: String, source: MediaSource)]) {
        let alertController = UIAlertController(title: "Select Source", message: "Choose your preferred source for AnimeLounge.", preferredStyle: .actionSheet)
        
        for (title, source) in sources {
            let action = UIAlertAction(title: title, style: .default) { _ in
                UserDefaults.standard.selectedMediaSource = source
                delegate?.didSelectNewSource()
            }
            setSourceImage(for: action, named: title)
            alertController.addAction(action)
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
    
    private static func showPopoverMenu(from viewController: UIViewController, sourceView: UIView?, sources: [(title: String, source: MediaSource)]) {
        let tableViewController = UITableViewController(style: .plain)
        tableViewController.tableView.isScrollEnabled = false
        tableViewController.preferredContentSize = CGSize(width: 250, height: CGFloat(sources.count * 44))
        
        tableViewController.tableView.dataSource = tableViewController
        tableViewController.tableView.delegate = tableViewController
        
        tableViewController.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SourceCell")
        
        let popoverController = tableViewController.popoverPresentationController
        popoverController?.delegate = tableViewController as? UIPopoverPresentationControllerDelegate
        popoverController?.permittedArrowDirections = .any
        
        if let sourceView = sourceView, sourceView.window != nil {
            popoverController?.sourceView = sourceView
            popoverController?.sourceRect = sourceView.bounds
        } else {
            popoverController?.sourceView = viewController.view
            popoverController?.sourceRect = viewController.view.bounds
        }
        
        tableViewController.tableView.dataSource = TableViewDataSource(sources: sources)
        tableViewController.tableView.delegate = TableViewDelegate(sources: sources) { selectedSource in
            UserDefaults.standard.selectedMediaSource = selectedSource
            delegate?.didSelectNewSource()
            tableViewController.dismiss(animated: true)
        }
        
        viewController.present(tableViewController, animated: true)
    }
    
    private static func setSourceImage(for action: UIAlertAction, named imageName: String) {
        guard let originalImage = UIImage(named: imageName) else { return }
        let resizedImage = originalImage.resized(to: CGSize(width: 35, height: 35))
        action.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
    }
}

protocol SourceSelectionDelegate: AnyObject {
    func didSelectNewSource()
}

class TableViewDataSource: NSObject, UITableViewDataSource {
    private let sources: [(title: String, source: MediaSource)]
    
    init(sources: [(title: String, source: MediaSource)]) {
        self.sources = sources
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath)
        let source = sources[indexPath.row]
        cell.textLabel?.text = source.title
        cell.imageView?.image = UIImage(named: source.title)?.resized(to: CGSize(width: 35, height: 35))
        return cell
    }
}

class TableViewDelegate: NSObject, UITableViewDelegate {
    private let sources: [(title: String, source: MediaSource)]
    private let onSelection: (MediaSource) -> Void
    
    init(sources: [(title: String, source: MediaSource)], onSelection: @escaping (MediaSource) -> Void) {
        self.sources = sources
        self.onSelection = onSelection
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSource = sources[indexPath.row].source
        onSelection(selectedSource)
    }
}
