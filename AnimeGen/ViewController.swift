//
//  ViewController.swift
//  AnimeGen
//
//  Created by Francesco on 26/01/25.
//

import UIKit
import Photos
import Kingfisher

enum ImageSource: String {
    case picRe = "picRe"
    case waifuIm = "waifuIm"
}

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var sourceButton: UIButton!
    
    var currentSource: ImageSource = .picRe
    var imageHistory: [URL] = []
    var currentImageIndex: Int = -1
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        
        if let savedSource = UserDefaults.standard.string(forKey: "selectedSource"),
           let imageSource = ImageSource(rawValue: savedSource) {
            currentSource = imageSource
        }
        
        setupSourceButtonMenu()
        loadNewImage()
    }
    
    func setupSourceButtonMenu() {
        sourceButton.menu = createSourceMenu()
        sourceButton.showsMenuAsPrimaryAction = true
    }
    
    func createSourceMenu() -> UIMenu {
        let picReAction = UIAction(title: "pic.re", image: nil, state: (currentSource == .picRe) ? .on : .off) { [weak self] (action) in
            self?.currentSource = .picRe
            self?.saveSelectedSource()
            self?.loadNewImage()
            self?.setupSourceButtonMenu()
        }
        
        let waifuImAction = UIAction(title: "waifu.im", image: nil, state: (currentSource == .waifuIm) ? .on : .off) { [weak self] (action) in
            self?.currentSource = .waifuIm
            self?.saveSelectedSource()
            self?.loadNewImage()
            self?.setupSourceButtonMenu()
        }
        
        return UIMenu(title: "Select Source", children: [picReAction, waifuImAction])
    }
    
    func loadNewImage() {
        activityIndicator.startAnimating()
        
        switch currentSource {
        case .picRe:
            fetchImageFromPicRe()
        case .waifuIm:
            fetchImageFromWaifuIm()
        }
    }
    
    func fetchImageFromPicRe() {
        guard let url = URL(string: "https://pic.re/image") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.custom.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching image from pic.re: \(error)")
                self.showErrorAlert(message: "Failed to load image from pic.re")
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let data = data else {
                print("No data received from pic.re")
                self.showErrorAlert(message: "No data received from pic.re")
                self.activityIndicator.stopAnimating()
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                   let fileURLString = json["file_url"] as? String,
                   let fileURL = URL(string: "https://" + fileURLString) {
                    DispatchQueue.main.async {
                        self.loadImage(from: fileURL)
                    }
                } else {
                    print("Error parsing pic.re JSON or 'file_url' not found")
                    self.showErrorAlert(message: "Error parsing pic.re JSON or 'file_url' not found")
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error decoding pic.re JSON: \(error)")
                self.showErrorAlert(message: "Error decoding pic.re JSON")
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
    
    func fetchImageFromWaifuIm() {
        let url = URL(string: "https://api.waifu.im/search?is_nsfw=false")!
        
        let task = URLSession.custom.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching waifu.im image: \(error)")
                self.showErrorAlert(message: "Failed to load image from waifu.im")
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let data = data else {
                print("No data received from waifu.im")
                self.showErrorAlert(message: "No data received from waifu.im")
                self.activityIndicator.stopAnimating()
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let images = json["images"] as? [[String: Any]],
                   let firstImage = images.first,
                   let imageUrlString = firstImage["url"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    DispatchQueue.main.async {
                        self.loadImage(from: imageUrl)
                    }
                } else {
                    print("Error parsing waifu.im JSON")
                    self.showErrorAlert(message: "Error parsing waifu.im JSON")
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Error decoding waifu.im JSON: \(error)")
                self.showErrorAlert(message: "Error decoding waifu.im JSON")
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
    
    func loadImage(from url: URL) {
        imageView.kf.setImage(with: url, options: [.keepCurrentImageWhileLoading]) { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success:
                if self.imageHistory.isEmpty || url != self.imageHistory.last {
                    self.imageHistory.append(url)
                }
                self.currentImageIndex = self.imageHistory.count - 1
            case .failure(let error):
                print("Error: \(error)")
                self.showErrorAlert(message: "Failed to load image.")
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        loadNewImage()
    }
    
    @IBAction func rewindButtonTapped(_ sender: UIButton) {
        guard !imageHistory.isEmpty else {
            print("No images in history.")
            return
        }
        
        if currentImageIndex > 0 {
            currentImageIndex -= 1
            let previousImageUrl = imageHistory[currentImageIndex]
            self.imageView.kf.setImage(with: previousImageUrl)
        } else {
            print("first image")
        }
        
        if currentImageIndex == 0 {
            showAlert(message: "This is the first image in history.")
        }
    }
    
    func saveSelectedSource() {
        UserDefaults.standard.set(currentSource.rawValue, forKey: "selectedSource")
    }
    
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else {
            print("No image available to save")
            return
        }
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .authorized, .limited:
                DispatchQueue.main.async {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
                }
            case .denied, .restricted:
                print("Photo library access denied or restricted.")
                self.showPhotoLibraryAccessDeniedAlert()
            case .notDetermined:
                print("Photo library access not determined.")
            @unknown default:
                print("Unknown authorization status")
            }
        }
    }
    
    @objc func imageCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
            showAlert(message: "Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved to photo library successfully!")
            showAlert(message: "Image saved to photo library successfully!")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showPhotoLibraryAccessDeniedAlert() {
        let alert = UIAlertController(
            title: "Photo Library Access Denied",
            message: "Please allow access to your photo library in Settings to save images.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
