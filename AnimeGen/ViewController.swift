//
//  ViewController.swift
//  AnimeGen
//
//  Created by cranci on 11/02/24.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    var imageView: UIImageView!
    
    var settingsButton: UIButton!
    
    var refreshButton: UIButton!
    var heartButton: UIButton!
    var rewindButton: UIButton!
    var shareButton: UIButton!
    var webButton: UIButton!
    var apiButton: UIButton!
    var historyButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var lastImage: UIImage?
    var tagsLabel: UILabel!
    
    var timeLabel: UILabel!
    var startTime: Date?
    var timer: Timer?
    
    var currentImageURL: String?
    
    var gradientLayer: CAGradientLayer?
    
    var enableAnimations = UserDefaults.standard.bool(forKey: "enableAnimations")
    var moetags = UserDefaults.standard.bool(forKey: "enableMoeTags")
    var gradient = UserDefaults.standard.bool(forKey: "enablegradient")
    var activity = UserDefaults.standard.bool(forKey: "enableTime")
    
    var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTime = Date()

        // Gestures
        let tripleTapGesture = UITapGestureRecognizer(target: self, action: #selector(heartButtonTapped))
        tripleTapGesture.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTapGesture)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(refreshButtonTapped))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rewindButtonTapped))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(settingsButtonTapped))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        
        // gradient
        if gradient {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0).cgColor, UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0).cgColor]
            view.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            view.backgroundColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1.0)
        }
        
        // Image View
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
    
        // Api Button
        apiButton = UIButton(type: .system)
        apiButton.setTitle("pic.re", for: .normal)
        apiButton.addTarget(self, action: #selector(apiButtonTapped), for: .touchUpInside)
        apiButton.translatesAutoresizingMaskIntoConstraints = false
        apiButton.backgroundColor = gradient ? UIColor(red: 0.4, green: 0.3, blue: 0.6, alpha: 1.0) : UIColor.darkGray
        apiButton.layer.cornerRadius = 10
        apiButton.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(apiButton)
        
        
        // History Button
        historyButton = UIButton(type: .system)
        let historyIcon = UIImage(systemName: "clock.arrow.circlepath")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
        historyButton.setImage(historyIcon, for: .normal)
        historyButton.tintColor = .systemGray
        historyButton.setTitleColor(.white, for: .normal)
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyButton)
        
        
        // Settings Button
        settingsButton = UIButton(type: .system)
        let settingsIcon = UIImage(systemName: "gear")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
        settingsButton.setImage(settingsIcon, for: .normal)
        settingsButton.tintColor = .systemGray
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsButton)
        
        
        // Web Button
        webButton = UIButton(type: .system)
        let webIcon = UIImage(systemName: "safari.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        webButton.setImage(webIcon, for: .normal)
        webButton.tintColor = .systemBlue
        webButton.addTarget(self, action: #selector(webButtonTapped), for: .touchUpInside)
        webButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webButton)
        
        // Refresh Button
        refreshButton = UIButton(type: .system)
        let refreshImage = UIImage(systemName: "arrow.clockwise.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 35, weight: .bold))
        refreshButton.setImage(refreshImage, for: .normal)
        refreshButton.tintColor = .systemTeal
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(refreshButton)

        // Heart Button
        heartButton = UIButton(type: .system)
        let heartImage = UIImage(systemName: "heart.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 35, weight: .bold))
        heartButton.setImage(heartImage, for: .normal)
        heartButton.tintColor = .systemRed
        heartButton.setTitleColor(.white, for: .normal)
        heartButton.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(heartButton)

        
        // Rewind Button
        rewindButton = UIButton(type: .system)
        let rewindImage = UIImage(systemName: "arrowshape.turn.up.backward.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 35, weight: .bold))
        rewindButton.setImage(rewindImage, for: .normal)
        rewindButton.tintColor = .systemGreen
        rewindButton.setTitleColor(.white, for: .normal)
        rewindButton.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        rewindButton.addTarget(self, action: #selector(rewindButtonTapped), for: .touchUpInside)
        rewindButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rewindButton)
        
        
        // Share Button
        shareButton = UIButton(type: .system)
        let shareImage = UIImage(systemName: "square.and.arrow.up.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        shareButton.setImage(shareImage, for: .normal)
        shareButton.tintColor = .systemPurple
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shareButton)

        
        // Activity Indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        
        // Tags
        tagsLabel = UILabel()
        tagsLabel.textColor = .white
        tagsLabel.textAlignment = .center
        tagsLabel.font = UIFont.systemFont(ofSize: 18)
        tagsLabel.numberOfLines = 0
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagsLabel)
        
        
        // Time Label
        timeLabel = UILabel()
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 18)
        timeLabel.numberOfLines = 0
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabel)

        timeLabel.isHidden = !activity

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        
        
        NSLayoutConstraint.activate([
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55),
            
            apiButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            apiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            apiButton.heightAnchor.constraint(equalToConstant: 40),
            apiButton.widthAnchor.constraint(equalToConstant: 120),
            
            historyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            historyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            webButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            webButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            heartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            heartButton.centerXAnchor.constraint(equalTo: refreshButton.centerXAnchor, constant: -60),
            
            rewindButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            rewindButton.centerXAnchor.constraint(equalTo: refreshButton.centerXAnchor, constant: 60),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: refreshButton.topAnchor, constant: -30),
            
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            shareButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            tagsLabel.topAnchor.constraint(equalTo: apiButton.bottomAnchor, constant: 16),
            tagsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            timeLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])

        loadImageAndTagsFromSelectedAPI()
    }
    
    func loadImageAndTagsFromSelectedAPI() {
        guard let title = apiButton.title(for: .normal) else {
            return
        }
        switch title {
        case "pic.re":
            loadImageAndTagsFromPicRe()
        case "waifu.im":
            loadImageAndTagsFromWaifuIm()
        case "nekos.best":
            loadImageAndTagsFromNekosBest()
        case "waifu.pics":
            loadImageFromWaifuPics()
        case "Hmtai":
            startHmtaiLoader()
        case "Nekos api":
            loadImageAndTagsFromNekosapi()
        case "nekos.moe":
            loadImageAndTagsFromNekosMoe()
        case "kyoko":
            loadImageAndTagsFromKyoko()
        case "Purr":
            loadImageAndTagsFromPurr()
        default:
            break
        }
    }

}
