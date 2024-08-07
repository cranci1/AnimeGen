//
//  ViewController.swift
//  AnimeGen
//
//  Created by cranci on 04/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    // Image Handling
    var imageHistory: [(UIImage, [String])] = []
    var currentPosition: Int = -1
    var currentImageURL: String?
    var lastImage: UIImage?
    var imageView: UIImageView!

    // IBOutlets
    @IBOutlet var RefreshButton: UIButton!
    @IBOutlet var HeartButton: UIButton!
    @IBOutlet var RewindButton: UIButton!
    @IBOutlet var WebButton: UIButton!
    @IBOutlet var ShareButton: UIButton!
    @IBOutlet var apiButton: UIButton!
    @IBOutlet var tagsLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    // Timer
    var startTime: Date?
    var timer: Timer?

    // User Defaults
    var enableAnimations = UserDefaults.standard.bool(forKey: "enableAnimations")
    var gradient = UserDefaults.standard.bool(forKey: "enablegradient")
    var activity = UserDefaults.standard.bool(forKey: "enableTime")
    var gestures = UserDefaults.standard.bool(forKey: "enableGestures")
    var loadstart = UserDefaults.standard.bool(forKey: "enableImageStartup")
    var TagsHide = UserDefaults.standard.bool(forKey: "enableTagsHide")
    var HistoryTrue = UserDefaults.standard.bool(forKey: "enableHistory")
    var alert = UserDefaults.standard.bool(forKey: "enableDeveloperAlert")
    var developerAPIs = UserDefaults.standard.bool(forKey: "enableDevAPIs")
    var lightmode = UserDefaults.standard.bool(forKey: "enabledLightMode")
    var parentsModeLoL = UserDefaults.standard.bool(forKey: "parentsModeLoL")

    // Choice Properties
    var counter: Int = 0
    let choices = ["waifu.im", "pic.re", "waifu.pics", "nekos.best", "Nekos api", "nekos.moe", "NekoBot", "nekos.life", "n-sfw.com", "Purr"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageWidths = Settings.shared.imageWidth
        let imageHeights = Settings.shared.imageHeight
        
        if #available(iOS 15.0, *) {
            if let image = UIImage(systemName: "square.and.arrow.up.circle.fill") {
                ShareButton.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(systemName: "square.and.arrow.up") {
                ShareButton.setImage(image, for: .normal)
            }
        }
        
        if let Webimage = UIImage(systemName: "safari.fill") {
            WebButton.setImage(Webimage, for: .normal)
        }
        
        startTime = Date()

        // Gestures
        if gestures {
            let tripleTapGesture = UITapGestureRecognizer(target: self, action: #selector(heartButtonTapped))
            tripleTapGesture.numberOfTapsRequired = 3
            view.addGestureRecognizer(tripleTapGesture)

            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(refreshButtonTapped))
            swipeLeft.direction = .left
            view.addGestureRecognizer(swipeLeft)

            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rewindButtonTapped))
            swipeRight.direction = .right
            view.addGestureRecognizer(swipeRight)
        }
        
        // Gradient
        if gradient {
            setupGradient()
            animateGradient()
        }
        
        // Image View
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        timeLabel.isHidden = !activity

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        
        NSLayoutConstraint.activate([
            
            // Image View
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: imageWidths),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: imageHeights),
            
            // API button
            apiButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            apiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            apiButton.heightAnchor.constraint(equalToConstant: 40),
            apiButton.widthAnchor.constraint(equalToConstant: 120),
            
            // Activity button
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: RefreshButton.topAnchor, constant: -30),
            
            // Tags label
            tagsLabel.topAnchor.constraint(equalTo: apiButton.bottomAnchor, constant: 16),
            tagsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Time label
            timeLabel.bottomAnchor.constraint(equalTo: RefreshButton.bottomAnchor, constant: 25),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
            ])
        
        if loadstart {
            loadImageAndTagsFromSelectedAPI()
        } else {
            self.activityIndicator.isHidden = true
        }
        
        // APIs Pref
        NotificationCenter.default.addObserver(self, selector: #selector(handleTags(_:)), name: Notification.Name("EnableTagsHide"), object: nil)
        
        // App Features
        NotificationCenter.default.addObserver(self, selector: #selector(handleGradient(_:)), name: Notification.Name("EnableGradient"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTime(_:)), name: Notification.Name("EnableTime"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGestures(_:)), name: Notification.Name("EnableGestures"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLightMode(_:)), name: Notification.Name("EnabledLightMode"), object: nil)
        
        // Content
        NotificationCenter.default.addObserver(self, selector: #selector(handleParentMode(_:)), name: Notification.Name("ParentsModeLoL"), object: nil)
        
        // Developer
        NotificationCenter.default.addObserver(self, selector: #selector(handleHmtaiShowcase(_:)), name: Notification.Name("EnableDevAPIs"), object: nil)
        
        // History
        NotificationCenter.default.addObserver(self, selector: #selector(handleHsistory(_:)), name: Notification.Name("EnableHistory"), object: nil)
        
        // Choice of the settings default app.
        let selectedChoiceIndex = UserDefaults.standard.integer(forKey: "SelectedChoiceIndex")
        apiButton.setTitle(choices[selectedChoiceIndex], for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectedChoiceChanged(_:)), name: Notification.Name("SelectedChoiceChanged"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Choice listener
    @objc func selectedChoiceChanged(_ notification: Notification) {
        guard let selectedIndex = notification.object as? Int else { return }
        guard selectedIndex >= 0 && selectedIndex < choices.count else { return }
        apiButton.setTitle(choices[selectedIndex], for: .normal)
    }
    
    // Function to make the Notification of the UserDefault work
    @objc func handleNotification(_ notification: Notification, key: String, action: (Bool) -> Void) {
        guard let userInfo = notification.userInfo,
              let isEnabled = userInfo[key] as? Bool else {
            return
        }
        action(isEnabled)
    }

    // load image from the api
    func loadImageAndTagsFromSelectedAPI() {
        guard let title = apiButton.title(for: .normal) else {
            return
        }

        let apiLoaders: [String: () -> Void] = [
            "pic.re": loadImageFromPicRe,
            "waifu.im": loadImageFromWaifuIm,
            "waifu.it": loadImageFromWaifuIt,
            "nekos.best": loadImageFromNekosBest,
            "waifu.pics": loadImageFromWaifuPics,
            "Nekos api": loadImageFromNekosapi,
            "nekos.moe": loadImageFromNekosMoe,
            "Hmtai api": startHmtaiLoader,
            "kyoko": loadImageFromKyoko,
            "Purr": loadImageFromPurr,
            "NekoBot": loadImageFromNekoBot,
            "Hmtai": startHmtaiLoader,
            "n-sfw.com": loadImageFromNSFW,
            "nekos.life": loadImageFromNekosLife
        ]

        apiLoaders[title]?()
    }
}

