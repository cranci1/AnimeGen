//
//  HistoryView.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import SwiftUI
import Photos

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isSaveAlertPresented = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                if #available(iOS 15.0, *) {
                    ImageGrid(selectedImage: $selectedImage, isSaveAlertPresented: $isSaveAlertPresented)
                } else {
                    ImageGridiOS13(selectedImage: $selectedImage, isSaveAlertPresented: $isSaveAlertPresented)
                }
                Button(action: clearImagesAndClose) {
                    HStack {
                        Image(systemName: "trash")
                            .font(.title)
                        Text("Clear History")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
                .padding(.top, 20)
            }
            .padding()
            .navigationBarTitle("History - \(ImageHistory.images.count) images", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $isSaveAlertPresented) {
            Alert(title: Text("Success"), message: Text("Image saved successfully"), dismissButton: .default(Text("OK")))
        }
    }
    
    func clearImagesAndClose() {
        ImageHistory.images.removeAll()
        presentationMode.wrappedValue.dismiss()
    }
}

@available(iOS 15.0, *)
struct ImageGrid: View {
    @Binding var selectedImage: UIImage?
    @Binding var isSaveAlertPresented: Bool
    @Environment(\.horizontalSizeClass) var sizeClass

    var columns: [GridItem] {
        Array(repeating: .init(.flexible()), count: sizeClass == .compact ? 3 : 5)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(ImageHistory.images.indices, id: \.self) { index in
                    let image = ImageHistory.images[index]
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(10)
                        .shadow(radius: 5)
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
        guard let imageData = image.jpegData(compressionQuality: 1.0),
              let uiImage = UIImage(data: imageData) else {
            print("Error converting image to JPEG format")
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
            creationRequest.creationDate = Date()
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("Image saved successfully")
                    isSaveAlertPresented = true
                } else {
                    print("Error saving image: \(error?.localizedDescription ?? "")")
                }
            }
        }
    }
}

struct ImageGridiOS13: View {
    @Binding var selectedImage: UIImage?
    @Binding var isSaveAlertPresented: Bool
    @Environment(\.horizontalSizeClass) var sizeClass

    var columns: Int {
        sizeClass == .compact ? 3 : 5
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<(ImageHistory.images.count / columns + (ImageHistory.images.count % columns > 0 ? 1 : 0)), id: \.self) { rowIndex in
                    HStack {
                        ForEach(0..<columns) { columnIndex in
                            let index = rowIndex * columns + columnIndex
                            if index < ImageHistory.images.count {
                                let image = ImageHistory.images[index]
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .onTapGesture {
                                        selectedImage = image
                                        saveImageToGallery(image)
                                    }
                            } else {
                                Spacer()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
            }
            .padding(10)
        }
    }
    
    func saveImageToGallery(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0),
              let uiImage = UIImage(data: imageData) else {
            print("Error converting image to JPEG format")
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
            creationRequest.creationDate = Date()
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("Image saved successfully")
                    isSaveAlertPresented = true
                } else {
                    print("Error saving image: \(error?.localizedDescription ?? "")")
                }
            }
        }
    }
}

struct ImageHistory {
    static var images: [UIImage] = []
    
    static func addImage(_ image: UIImage) {
        images.append(image)
    }
}
