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
            print("No image found in imageView")
            return
        }

        if let data = image.imageData,
           let source = CGImageSourceCreateWithData(data as CFData, nil),
           let utType = CGImageSourceGetType(source),
           UTTypeConformsTo(utType, kUTTypeGIF) {

            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: data, options: nil)
            }) { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        print("GIF image saved to Photos library")
                        self.animateFeedback()
                    } else {
                        self.handleSaveError(error, isGIF: true)
                    }
                }
            }
            return
        }

        if let imageData = image.jpegData(compressionQuality: 1.0),
           let uiImage = UIImage(data: imageData) {
            UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            print("Error converting image to JPEG format")
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
            showAlert(withTitle: "Error Saving Image!", message: "You didn't allow AnimeGen to access the Photo Library.", viewController: self)
        } else {
            animateFeedback()
            print("Image saved successfully")
        }
    }

    private func handleSaveError(_ error: Error?, isGIF: Bool) {
        let imageType = isGIF ? "GIF" : "image"
        let errorMessage = error?.localizedDescription ?? "Unknown error"
        print("Error saving \(imageType): \(errorMessage)")
        showAlert(withTitle: "Error Saving \(imageType.capitalized)!", message: "You didn't allow AnimeGen to access the Photo Library.", viewController: self)
    }
}
