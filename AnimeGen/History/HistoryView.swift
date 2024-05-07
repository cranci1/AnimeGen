//
//  HistoryView.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import SwiftUI
import Photos

struct ImageWrapper: Identifiable {
    let id = UUID()
    let image: UIImage
}

struct HistoryView: View {
    @State private var isSaveAlertPresented = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                ImageGrid(selectedImage: $selectedImage, isSaveAlertPresented: $isSaveAlertPresented)
                    .navigationBarTitle("History - \(ImageHistory.images.count) images")
            } else {
                ImageGridiOS13(selectedImage: $selectedImage, isSaveAlertPresented: $isSaveAlertPresented)
                    .navigationBarTitle("History - \(ImageHistory.images.count) images")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $isSaveAlertPresented) {
            Alert(title: Text("Success"), message: Text("Image saved successfully"), dismissButton: .default(Text("OK")))
        }
    }
}

@available(iOS 15.0, *)
struct ImageGrid: View {
    @Binding var selectedImage: UIImage?
    @Binding var isSaveAlertPresented: Bool
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(ImageHistory.images.indices, id: \.self) { index in
                    let image = ImageHistory.images[index]
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            selectedImage = image
                            saveImageToGallery(image)
                        }
                }
            }
            .padding(10)
        }
    }
    
    func saveImageToGallery(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0),
           let uiImage = UIImage(data: imageData) {
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
                creationRequest.creationDate = Date()
            } completionHandler: { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        print("Image saved successfully")
                        self.isSaveAlertPresented = true
                    } else {
                        print("Error saving image: \(error?.localizedDescription ?? "")")
                    }
                }
            }
        } else {
            print("Error converting image to JPEG format")
        }
    }
}

struct ImageGridiOS13: View {
    @Binding var selectedImage: UIImage?
    @Binding var isSaveAlertPresented: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(ImageHistory.images.indices, id: \.self) { index in
                    let image = ImageHistory.images[index]
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            selectedImage = image
                            saveImageToGallery(image)
                        }
                }
            }
            .padding(10)
        }
    }
    
    func saveImageToGallery(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0),
           let uiImage = UIImage(data: imageData) {
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
                creationRequest.creationDate = Date()
            } completionHandler: { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        print("Image saved successfully")
                        self.isSaveAlertPresented = true
                    } else {
                        print("Error saving image: \(error?.localizedDescription ?? "")")
                    }
                }
            }
        } else {
            print("Error converting image to JPEG format")
        }
    }
}
