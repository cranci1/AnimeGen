//
//  Created by Francesco on 26/01/25.
//

import UIKit
import Kingfisher

enum ImageSource {
    case picRe
    case waifuIm
}

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var sourceButton: UIButton!
    
    var currentSource: ImageSource = .picRe
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self?.loadNewImage()
            self?.setupSourceButtonMenu()
        }
        
        let waifuImAction = UIAction(title: "waifu.im", image: nil, state: (currentSource == .waifuIm) ? .on : .off) { [weak self] (action) in
            self?.currentSource = .waifuIm
            self?.loadNewImage()
            self?.setupSourceButtonMenu()
        }
        
        return UIMenu(title: "Select Source", children: [picReAction, waifuImAction])
    }
    
    func loadNewImage() {
        switch currentSource {
        case .picRe:
            fetchImageFromPicRe()
        case .waifuIm:
            fetchImageFromWaifuIm()
        }
    }
    
    func fetchImageFromPicRe() {
        let imageUrl = URL(string: "https://pic.re/image")!
        loadImage(from: imageUrl)
    }
    
    func fetchImageFromWaifuIm() {
        let url = URL(string: "https://api.waifu.im/search?is_nsfw=true")!
        
        let task = URLSession.custom.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching waifu.im image: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received from waifu.im")
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
                }
            } catch {
                print("Error decoding waifu.im JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    func loadImage(from url: URL) {
        imageView.kf.setImage(with: url) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        loadNewImage()
    }
}
