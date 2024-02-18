//
//  ViewController.swift
//  AnimeGen
//
//  Created by cranci on 11/02/24.
//

import UIKit
import SwiftUI
import MobileCoreServices

import WebKit

import SDWebImage
import Photos

class ViewController: UIViewController {

    var imageView: UIImageView!
    
    var settingsButton: UIButton!
    
    var refreshButton: UIButton!
    var heartButton: UIButton!
    var rewindButton: UIButton!
    var shareButton: UIButton!
    var webButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var lastImage: UIImage?
    var tagsLabel: UILabel!
    
    var apiButton: UIButton!
    
    var currentImageURL: String?
    
    var enableAnimations = UserDefaults.standard.bool(forKey: "enableAnimations")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tripleTapGesture = UITapGestureRecognizer(target: self, action: #selector(heartButtonTapped))
        tripleTapGesture.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTapGesture)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(refreshButtonTapped))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rewindButtonTapped))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        view.backgroundColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1.0)

        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55)
        ])


        apiButton = UIButton(type: .system)
        apiButton.setTitle("pic.re", for: .normal)
        apiButton.addTarget(self, action: #selector(apiButtonTapped), for: .touchUpInside)
        apiButton.translatesAutoresizingMaskIntoConstraints = false

        apiButton.backgroundColor = UIColor.darkGray
        apiButton.layer.cornerRadius = 10

        apiButton.setTitleColor(UIColor.white, for: .normal)

        view.addSubview(apiButton)

        NSLayoutConstraint.activate([
            apiButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            apiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            apiButton.heightAnchor.constraint(equalToConstant: 40),
            apiButton.widthAnchor.constraint(equalToConstant: 120)
        ])
        
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

        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
        
        let webButton = UIButton(type: .system)
        let webIcon = UIImage(systemName: "safari.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        webButton.setImage(webIcon, for: .normal)
        webButton.tintColor = .systemBlue
        webButton.setTitleColor(.white, for: .normal)
        webButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        webButton.addTarget(self, action: #selector(webButtonTapped), for: .touchUpInside)
        webButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webButton)

        NSLayoutConstraint.activate([
            webButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            webButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])

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

        NSLayoutConstraint.activate([
            refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

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

        NSLayoutConstraint.activate([
            heartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            heartButton.centerXAnchor.constraint(equalTo: refreshButton.centerXAnchor, constant: -60),
        ])

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

        NSLayoutConstraint.activate([
            rewindButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            rewindButton.centerXAnchor.constraint(equalTo: refreshButton.centerXAnchor, constant: 60),
        ])

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: refreshButton.topAnchor, constant: -30)
        ])

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

        NSLayoutConstraint.activate([
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            shareButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        tagsLabel = UILabel()
        tagsLabel.textColor = .white
        tagsLabel.textAlignment = .center
        tagsLabel.font = UIFont.systemFont(ofSize: 18)
        tagsLabel.numberOfLines = 0
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagsLabel)

        NSLayoutConstraint.activate([
            tagsLabel.topAnchor.constraint(equalTo: apiButton.bottomAnchor, constant: 16),
            tagsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
            loadImagesFromHmtai()
        case "Nekos api":
            loadImageAndTagsFromNekosapi()
        default:
            break
        }
    }
    
    @objc func shareButtonTapped() {
        guard let currentImage = imageView.image else {
            print("No image available for sharing.")
            return
        }

        let shareController = UIActivityViewController(
            activityItems: [currentImage],
            applicationActivities: nil
        )
            shareController.popoverPresentationController?.sourceView = view
            present(shareController, animated: true, completion: nil)
        }


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
            loadImagesFromHmtai()
        case "Nekos api":
            lastImage = imageView.image
            loadImageAndTagsFromNekosapi()
        default:
            break
        }
    }

    
    @objc func apiButtonTapped() {
        let alertController = UIAlertController(title: "Select API", message: nil, preferredStyle: .actionSheet)

        let apiOptions = ["Nekos api", "Hmtai", "waifu.pics", "nekos.best", "waifu.im", "pic.re"]
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

    @objc func heartButtonTapped() {
        guard let image = imageView.image else {
            return
        }

        if let data = image.imageData,
           let source = CGImageSourceCreateWithData(data as CFData, nil),
           let utType = CGImageSourceGetType(source),
           UTTypeConformsTo(utType, kUTTypeGIF) {

            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: data, options: nil)
            } completionHandler: { (success, error) in
                if success {
                    print("GIF image saved to Photos library")
                    self.animateFeedback()
                } else {
                    print("Error saving GIF image: \(error?.localizedDescription ?? "")")
                }
            }
            return
        }

        if let imageData = image.jpegData(compressionQuality: 1.0),
            let uiImage = UIImage(data: imageData) {

            DispatchQueue.main.async {
                UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        } else {
            print("Error converting image to JPEG format")
        }
    }
    
    @objc func rewindButtonTapped() {
        if let lastImage = lastImage {
            animateImageChange(with: lastImage)
        }
    }
    
    @objc func settingsButtonTapped() {
        let settingsPage = SettingsPage()
        let hostingController = UIHostingController(rootView: settingsPage)

        present(hostingController, animated: true, completion: nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully!")
            animateFeedback()
        }
    }
    
    @objc func webButtonTapped() {
        if let urlString = currentImageURL, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
