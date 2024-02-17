//
//  waifu-im.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

extension ViewController {
    
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

                          let tags = tagsArray.compactMap { $0["name"] as? String }

                          if let data = try? Data(contentsOf: imageUrl), let newImage = UIImage(data: data) {
                              self.imageView.image = newImage
                              self.animateImageChange(with: newImage)

                              self.updateUIWithTags(tags)

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
    
}
