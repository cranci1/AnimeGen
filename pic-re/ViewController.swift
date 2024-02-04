import UIKit

class ViewController: UIViewController {

    var imageView: UIImageView!
    var refreshButton: UIButton!
    var heartButton: UIButton!
    var rewindButton: UIButton!
    var shareButton: UIButton!
    var activityIndicator: UIActivityIndicatorView!
    var lastImage: UIImage?
    var tagsLabel: UILabel!


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
            imageView.widthAnchor.constraint(equalToConstant: 340),
            imageView.heightAnchor.constraint(equalToConstant: 560)
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
            refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
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
            heartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
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
            rewindButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
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
            tagsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tagsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Initial load
        loadImageAndTagsFromPicRe()
    }

    @objc func shareButtonTapped() {
        guard let currentImage = imageView.image else {
            return
        }
        
        guard let appIcon = UIImage(named: "test") else {
            return
        }

        let customTitle = "pic.re"

        let shareController = UIActivityViewController(activityItems: [customTitle, appIcon, currentImage], applicationActivities: nil)
        shareController.popoverPresentationController?.sourceView = view
        present(shareController, animated: true, completion: nil)
    }


    @objc func refreshButtonTapped() {
        lastImage = imageView.image
        loadImageAndTagsFromPicRe()
    }

    @objc func heartButtonTapped() {
        // Ensure imageView.image is not nil
        guard let image = imageView.image else {
            return
        }

        // Convert the image to JPEG format
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

            if let imageTagsString = httpResponse.allHeaderFields["image_tags"] as? String {
                let tags = imageTagsString.components(separatedBy: ",")
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

    func loadTagsFromPicRe(completion: @escaping ([String]) -> Void) {
        let apiEndpoint = "https://pic.re/image"

        guard let url = URL(string: apiEndpoint) else {
            print("Invalid URL")
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion([])
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid HTTP response")
                completion([])
                return
            }

            if let imageTagsString = httpResponse.allHeaderFields["image_tags"] as? String {
                let tags = imageTagsString.components(separatedBy: ",")
                completion(tags)
            } else {
                print("No image tags found in response headers.")
                completion([])
            }
        }

        task.resume()
    }

    func updateUIWithTags(_ tags: [String]) {
        let tagsString = tags.joined(separator: ", ")
        
        let attributedString = NSMutableAttributedString(string: "Tags: \(tagsString)")
        
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        attributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 5))
        
        tagsLabel.attributedText = attributedString
    }

    
    
}
