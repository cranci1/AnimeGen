//
//  ViewController.swift
//  AnimeGen
//
//  Created by cranci on 04/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    var imageHistory: [(UIImage, [String])] = []
    var currentPosition: Int = -1

    var currentImageURL: String?
    var lastImage: UIImage?
    var tagsLabel: UILabel!

    var timeLabel: UILabel!
    var startTime: Date?
    var timer: Timer?
    
    var imageView: UIImageView!
    
    var apiButton: UIButton!
    var shareButton: UIButton!
    var webButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var RefreshButton: UIButton!
    @IBOutlet var HeartButton: UIButton!
    @IBOutlet var RewindButton: UIButton!
    
    var enableAnimations = UserDefaults.standard.bool(forKey: "enableAnimations")
    var gradient = UserDefaults.standard.bool(forKey: "enablegradient")
    var activity = UserDefaults.standard.bool(forKey: "enableTime")
    var gestures = UserDefaults.standard.bool(forKey: "enableGestures")
    
    var loadstart = UserDefaults.standard.bool(forKey: "enableImageStartup")
    var moetags = UserDefaults.standard.bool(forKey: "enableMoeTags")
    // var kyokobanner = UserDefaults.standard.bool(forKey: "enableKyokobanner")
    
    var HistoryTrue = UserDefaults.standard.bool(forKey: "enableHistory")
    
    var alert = UserDefaults.standard.bool(forKey: "enableDeveloperAlert")
    var developerAPIs = UserDefaults.standard.bool(forKey: "enableDevAPIs")
    
    var lightmode = UserDefaults.standard.bool(forKey: "enabledLightMode")
    
    var parentsModeLoL = UserDefaults.standard.bool(forKey: "parentsModeLoL")
    
    var buttons = UserDefaults.standard.bool(forKey: "enableButtons")
    
    var counter: Int = 0
    
    let choices = ["waifu.im", "pic.re", "waifu.pics", "waifu.it", "nekos.best", "Nekos api", "nekos.moe", "NekoBot", "n-sfw.com", "Purr"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageWidths = Settings.shared.imageWidth
        let imageHeights = Settings.shared.imageHeight
        
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
        } else if !lightmode {
            view.backgroundColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1.0)
        } else if lightmode {
            view.backgroundColor = UIColor.white
        }
        
        // Image View
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        if buttons {
            
        // Api Button
        apiButton = UIButton(type: .system)
        apiButton.setTitle("", for: .normal)
        apiButton.addTarget(self, action: #selector(apiButtonTapped), for: .touchUpInside)
        apiButton.translatesAutoresizingMaskIntoConstraints = false
        if gradient {
            apiButton.backgroundColor = UIColor(red: 0.4, green: 0.3, blue: 0.6, alpha: 1.0)
        } else if !lightmode {
            apiButton.backgroundColor = UIColor.darkGray
        } else if lightmode {
            apiButton.backgroundColor = UIColor.lightGray
        }
        apiButton.layer.cornerRadius = 10
        apiButton.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(apiButton)
        
        
        // Activity Indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        if !lightmode {
            activityIndicator.color = .white
        } else {
            activityIndicator.color = .black
        }
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        
        // Web Button
        webButton = UIButton(type: .system)
        let webIcon = UIImage(systemName: "safari.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        webButton.setImage(webIcon, for: .normal)
        webButton.tintColor = .systemBlue
        webButton.addTarget(self, action: #selector(webButtonTapped), for: .touchUpInside)
        webButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webButton)
        
        
        // Share Button
        shareButton = UIButton(type: .system)
        if #available(iOS 15.0, *) {
            let shareImage = UIImage(systemName: "square.and.arrow.up.circle.fill")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
            shareButton.setImage(shareImage, for: .normal)
        } else {
            let secondShareImage = UIImage(systemName: "square.and.arrow.up")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
            shareButton.setImage(secondShareImage, for: .normal)
        }
        shareButton.tintColor = .systemPurple
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shareButton)
            
        }
        
        
        // Tags Label
        tagsLabel = UILabel()
        if !lightmode{
            tagsLabel.textColor = .white
        } else {
            tagsLabel.textColor = .black
        }
        tagsLabel.textAlignment = .center
        tagsLabel.font = UIFont.systemFont(ofSize: 18)
        tagsLabel.numberOfLines = 0
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagsLabel)
        
        
        // Time Label
        timeLabel = UILabel()
        if !lightmode{
            timeLabel.textColor = .white
        } else {
            timeLabel.textColor = .black
        }
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 18)
        timeLabel.numberOfLines = 0
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabel)
        
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
            
            // Web button
            webButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            webButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            // Share button
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            shareButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
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
        }
        
        // APIs Pref
        NotificationCenter.default.addObserver(self, selector: #selector(handleMoeTags(_:)), name: Notification.Name("EnableMoeTagsChanged"), object: nil)
        
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
        
        if loadstart {
            loadImageAndTagsFromSelectedAPI()
        }
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
            "n-sfw.com": loadImageFromNSFW
        ]

        apiLoaders[title]?()
    }
}

