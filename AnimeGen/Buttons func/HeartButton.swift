//
//  HeartButton.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit
import Photos
import MobileCoreServices

extension ViewController {

    @IBAction func heartButtonTapped() {
        guard let image = imageView.image else {
            showAlert(withTitle: "No Image", message: "There is no image to save.", viewController: self)
            return
        }

        if let data = image.imageData,
           let source = CGImageSourceCreateWithData(data as CFData, nil),
           let utType = CGImageSourceGetType(source),
           UTTypeConformsTo(utType, kUTTypeGIF) {
            saveGIFImage(data: data)
        } else if let imageData = image.jpegData(compressionQuality: 1.0),
                  let uiImage = UIImage(data: imageData) {
            saveJPEGImage(uiImage: uiImage)
        } else {
            print("Error converting image to JPEG format")
        }
    }

    private func saveGIFImage(data: Data) {
        PHPhotoLibrary.shared().performChanges {
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: data, options: nil)
        } completionHandler: { [weak self] success, error in
            guard let self = self else { return }
            if success {
                print("GIF image saved to Photos library")
                self.animateFeedback()
            } else {
                print("Error saving GIF image: \(error?.localizedDescription ?? "")")
                self.showAlert(withTitle: "Error Saving Image!", message: "You didn't allow AnimeGen to access the Photo Library.", viewController: self)
            }
        }
    }
    
    private func saveJPEGImage(uiImage: UIImage) {
        UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
            self.showAlert(withTitle: "Error Saving Image!", message: "You didn't allow AnimeGen to access the Photo Library.", viewController: self)
        } else {
            self.animateFeedback()
            print("Image saved successfully")
        }
    }
}
