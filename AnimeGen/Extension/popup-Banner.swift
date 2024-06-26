//
//  popup-Banner.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

extension ViewController {
    
    func showPopUpBanner(message: String, viewController: UIViewController, completion: (() -> Void)?) {
         if #available(iOS 14.0, *) {
             // nothing here cuz ios 14+ 💪
             completion?()
         } else {
             
             // ios 13.x 😭
            
             let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
             let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                 completion?()
             }
             alertController.addAction(okAction)
             viewController.present(alertController, animated: true, completion: nil)
         }
     }
    
    func showAlert(withTitle title: String, message: String, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
