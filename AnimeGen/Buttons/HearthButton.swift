//
//  HearthButton.swift
//  AnimeGen
//
//  Created by cranci on 20/03/24.
//

import UIKit
import Photos
import MobileCoreServices

extension ViewController {

    @objc func heartButtonTapped() {
        guard let image = imageView.image else {
            return
        }

        if let data = image.imageData,
           let source = CGImageSourceCreateWithData(data as CFData, nil),
           let utType = CGImageSourceGetType(source) as String?,
           UTType(utType)?.conforms(to: .gif) == true {
           
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

    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully")
        }
    }
}
