//
//  ViewController.swift
//  AnimeGen
//
//  Created by cranci on 11/02/24.
//

import UIKit
import MobileCoreServices
import WebKit

class ViewController: UIViewController {

    var imageView: UIImageView!
    
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

        // Create UIImageView
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        // Set constraints for UIImageView
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

        // Set background color and corner radius for the API button
        apiButton.backgroundColor = UIColor.darkGray // You can replace UIColor.blue with the color you prefer
        apiButton.layer.cornerRadius = 10 // Adjust the corner radius as needed

        // Set text color for the button
        apiButton.setTitleColor(UIColor.white, for: .normal)

        view.addSubview(apiButton)

        // Set constraints for the API button
        NSLayoutConstraint.activate([
            apiButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            apiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            apiButton.heightAnchor.constraint(equalToConstant: 40), // Adjust the height as needed
            apiButton.widthAnchor.constraint(equalToConstant: 120) // Adjust the width as needed
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

        // Set constraints for the web button
        NSLayoutConstraint.activate([
            webButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            webButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])

        // Add the refresh button
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

        // Set constraints for UIButton
        NSLayoutConstraint.activate([
            refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        // Add the heart button
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

        // Set constraints for the heart button
        NSLayoutConstraint.activate([
            heartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            heartButton.centerXAnchor.constraint(equalTo: refreshButton.centerXAnchor, constant: -60),
        ])

        // Add the rewind button
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

        // Set constraints for the rewind button
        NSLayoutConstraint.activate([
            rewindButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            rewindButton.centerXAnchor.constraint(equalTo: refreshButton.centerXAnchor, constant: 60),
        ])

        // Loading indicator setup
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        // Set constraints for the activity indicator
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

        // Set constraints for the share button
        NSLayoutConstraint.activate([
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            shareButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        tagsLabel = UILabel()
        tagsLabel.textColor = .white
        tagsLabel.textAlignment = .center
        tagsLabel.font = UIFont.systemFont(ofSize: 18)
        tagsLabel.numberOfLines = 0 // Allow multiple lines if needed
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagsLabel)

        // Set constraints for tagsLabel
        NSLayoutConstraint.activate([
            tagsLabel.topAnchor.constraint(equalTo: apiButton.bottomAnchor, constant: 16),
            tagsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        loadImageAndTagsFromSelectedAPI()
    }
    
    @objc func apiSegmentChanged() {
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
        default:
            break
        }
    }
    
    
    func loadImageAndTagsFromNekosBest() {
        startLoadingIndicator()

        let categories = ["neko", "waifu", "kitsune"]
        let randomCategory = categories.randomElement() ?? "waifu"

        let apiEndpoint = "https://nekos.best/api/v2/\(randomCategory)"

        guard let url = URL(string: apiEndpoint) else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    self.stopLoadingIndicator()
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid HTTP response")
                    self.stopLoadingIndicator()
                    return
                }

                // Check if the response status code is OK (200)
                guard httpResponse.statusCode == 200 else {
                    print("Invalid status code: \(httpResponse.statusCode)")
                    self.stopLoadingIndicator()
                    return
                }

                do {
                    // Inside loadImageAndTagsFromNekosBest function
                    if let jsonData = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let results = jsonResponse["results"] as? [[String: Any]],
                       let result = results.first,
                       let imageUrlString = result["url"] as? String,
                       let imageUrl = URL(string: imageUrlString) {

                        // Store the current image URL
                        self.currentImageURL = imageUrlString

                        let author = result["artist_name"] as? String
                        let category = randomCategory

                        // Update UI with image and additional information
                        if let data = try? Data(contentsOf: imageUrl), let newImage = UIImage(data: data) {
                            self.imageView.image = newImage
                            self.animateImageChange(with: newImage)
                            self.updateUIWithTags([], author: author, category: category)
                            self.stopLoadingIndicator()
                        } else {
                            print("Failed to load image data.")
                            self.stopLoadingIndicator()
                        }
                    } else {
                        print("Failed to parse JSON response or missing necessary data.")
                        self.stopLoadingIndicator()
                    }
                }
            }
        }

        task.resume()
    }
    
    func loadImageFromWaifuPics() {
        startLoadingIndicator()

        let categories = ["waifu", "neko", "shinobu", "cuddle", "hug", "kiss", "lick", "pat", "bonk", "blush", "smile", "nom", "bite", "glomp", "slap", "kick", "happy", "poke", "dance"]
        let randomCategory2 = categories.randomElement() ?? "waifu"

        let apiEndpoint = "https://api.waifu.pics/sfw/\(randomCategory2)"

        guard let url = URL(string: apiEndpoint) else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    self.stopLoadingIndicator()
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid HTTP response")
                    self.stopLoadingIndicator()
                    return
                }

                if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let imageUrlString = jsonResponse["url"] as? String, let imageUrl = URL(string: imageUrlString) {

                    if let imageData = try? Data(contentsOf: imageUrl) {
                        if imageUrlString.lowercased().hasSuffix(".gif") {
                            // Display GIF
                            if let animatedImage = UIImage.animatedImage(with: UIImage.gifData(data: imageData) ?? [], duration: 1.0) {
                                self.imageView.image = animatedImage
                                self.animateImageChange(with: animatedImage)
                            } else {
                                print("Failed to create animated image from GIF data.")
                            }
                        } else {
                            // Display static image
                            if let newImage = UIImage(data: imageData) {
                                self.imageView.image = newImage
                                self.animateImageChange(with: newImage)
                            } else {
                                print("Failed to load image data.")
                            }
                        }

                        let category2 = randomCategory2
                        let author2 = "Waifu.pics"
                        
                        self.currentImageURL = imageUrlString

                        // Display the category
                        self.updateUIWithTags([], author: author2, category: category2)

                        self.stopLoadingIndicator()
                    } else {
                        print("Failed to load image data.")
                        self.stopLoadingIndicator()
                    }
                } else {
                    print("Failed to parse JSON response or missing necessary data.")
                    self.stopLoadingIndicator()
                }
            }
        }

        task.resume()
    }
    


    func loadImageAndTagsFromWaifuIm() {
          startLoadingIndicator()

          let apiEndpoint = "https://api.waifu.im/search?"

          guard let url = URL(string: apiEndpoint) else {
              print("Invalid URL")
              stopLoadingIndicator()
              return
          }

          var request = URLRequest(url: url)
          request.httpMethod = "GET"

          let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
              DispatchQueue.main.async {
                  if let error = error {
                      print("Error: \(error)")
                      self.stopLoadingIndicator()
                      return
                  }

                  guard let httpResponse = response as? HTTPURLResponse else {
                      print("Invalid HTTP response")
                      self.stopLoadingIndicator()
                      return
                  }

                  // Check if the response status code is OK (200)
                  guard httpResponse.statusCode == 200 else {
                      print("Invalid status code: \(httpResponse.statusCode)")
                      self.stopLoadingIndicator()
                      return
                  }

                  do {
                      if let jsonData = data,
                         let jsonResponse = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                         let images = jsonResponse["images"] as? [[String: Any]],
                         let firstImage = images.first,
                         let imageUrlString = firstImage["url"] as? String,
                         let imageUrl = URL(string: imageUrlString),
                         let tagsArray = firstImage["tags"] as? [[String: Any]] {
                          
                          self.currentImageURL = imageUrlString

                          // Extract tag names
                          let tags = tagsArray.compactMap { $0["name"] as? String }

                          // Update UI with image and tags
                          if let data = try? Data(contentsOf: imageUrl), let newImage = UIImage(data: data) {
                              self.imageView.image = newImage
                              self.animateImageChange(with: newImage)

                              // Explicitly call updateUIWithTags here
                              self.updateUIWithTags(tags)

                              self.stopLoadingIndicator()
                          } else {
                              print("Failed to load image data.")
                              self.stopLoadingIndicator()
                          }
                      } else {
                          print("Failed to extract necessary data from JSON.")
                          self.stopLoadingIndicator()
                      }
                  }
              }
          }

          task.resume()
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
        default:
            break
        }
    }

    
    @objc func apiButtonTapped() {
        // Create a UIAlertController with options
        let alertController = UIAlertController(title: "Select API", message: nil, preferredStyle: .actionSheet)

        // Add actions for each API option
        let apiOptions = ["pic.re", "waifu.im", "nekos.best", "waifu.pics"]
        for option in apiOptions {
            let action = UIAlertAction(title: option, style: .default) { _ in
                self.apiButton.setTitle(option, for: .normal)
                self.loadImageAndTagsFromSelectedAPI()
            }
            alertController.addAction(action)
        }

        // Add cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        // Present the UIAlertController
        alertController.popoverPresentationController?.sourceView = apiButton
        alertController.popoverPresentationController?.sourceRect = apiButton.bounds
        present(alertController, animated: true, completion: nil)
    }

    @objc func heartButtonTapped() {
        // Ensure imageView.image is not nil
        guard let image = imageView.image else {
            return
        }

        // Check if the image is a GIF using CGImageSource
        if let data = image.jpegData(compressionQuality: 1.0),
           let source = CGImageSourceCreateWithData(data as CFData, nil),
           let utType = CGImageSourceGetType(source),
           UTTypeConformsTo(utType, kUTTypeGIF) {

            // Image is a GIF, save the original image
            DispatchQueue.main.async {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            return
        }

        // Image is not a GIF, convert to JPEG format
        if let imageData = image.jpegData(compressionQuality: 1.0),
            let uiImage = UIImage(data: imageData) {

            // Save the converted image
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


    func startLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    func stopLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    func animateFeedback() {
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.imageView.transform = CGAffineTransform.identity
            }
        }
    }

    func animateImageChange(with newImage: UIImage) {
        UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imageView.image = newImage
        }, completion: nil)
    }

    func loadImageAndTagsFromPicRe() {
        startLoadingIndicator()

        let apiEndpoint = "https://pic.re/image"

        guard let url = URL(string: apiEndpoint) else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                self.stopLoadingIndicator()
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid HTTP response")
                self.stopLoadingIndicator()
                return
            }

            // Check if the response status code is OK (200)
            guard httpResponse.statusCode == 200 else {
                print("Invalid status code: \(httpResponse.statusCode)")
                self.stopLoadingIndicator()
                return
            }

            // Extract tags from response headers
            if let imageTagsString = httpResponse.allHeaderFields["image_tags"] as? String,
               let imageUrlString = httpResponse.allHeaderFields["image_source"] as? String {
                let tags = imageTagsString.components(separatedBy: ",")

                // Store the current image URL
                self.currentImageURL = imageUrlString

                DispatchQueue.main.async {
                    self.updateUIWithTags(tags)
                }
            } else {
                print("No image tags found in response headers.")
                self.stopLoadingIndicator()
                return
            }

            guard let data = data, let newImage = UIImage(data: data) else {
                print("Invalid image data")
                self.stopLoadingIndicator()
                return
            }

            DispatchQueue.main.async {
                self.imageView.image = newImage
                self.animateImageChange(with: newImage)
                self.stopLoadingIndicator()
            }
        }

        task.resume()
    }

    func updateUIWithTags(_ tags: [String], author: String? = nil, category: String? = nil) {
            var tagsString = "Tags: \(tags.joined(separator: ", "))"

            if let author = author, let category = category {
                tagsString += "\nAuthor: \(author)"
                tagsString += "\nCategory: \(category)"
            }

            let attributedString = NSMutableAttributedString(string: tagsString)

            let boldAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]

            attributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 5))

            tagsLabel.attributedText = attributedString
        }
 
}

extension UIImage {
    class func gifData(data: Data) -> [UIImage]? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []

        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            images.append(UIImage(cgImage: cgImage))
        }

        return images
    }
}
