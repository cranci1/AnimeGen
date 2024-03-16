//
//  IconPage.swift
//  AnimeGen
//
//  Created by cranci on 28/02/24.
//

import SwiftUI

class IconNames: ObservableObject {
    @Published var iconNames: [String] = []
    @Published var currentIndex = 0

    init() {
        getAlternateIcons()
        if let currentIcon = UIApplication.shared.alternateIconName,
           let index = iconNames.firstIndex(of: currentIcon) {
            self.currentIndex = index
        }
    }

    func getAlternateIcons() {
        if let iconsDictionary = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
           let alternateIcons = iconsDictionary["CFBundleAlternateIcons"] as? [String: Any] {
            for (_, value) in alternateIcons {
                if let iconList = value as? [String: Any],
                   let iconFiles = iconList["CFBundleIconFiles"] as? [String],
                   let icon = iconFiles.first {
                    iconNames.append(icon)
                }
            }
        }
    }
}

struct IconPage: View {
    @EnvironmentObject var iconSettings: IconNames
    @State private var showErrorAlert = false

    var body: some View {
        List {
            ForEach(iconSettings.iconNames.indices, id: \.self) { index in
                Button(action: {
                    changeAppIcon(index: index)
                }) {
                    HStack {
                        Image(uiImage: UIImage(named: iconSettings.iconNames[index]) ?? UIImage())
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))

                        Text(iconSettings.iconNames[index])
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(1)
                            .padding(.leading, 8)

                        Spacer()
                    }
                }
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"),
                  message: Text("Failed to change app icon. Please try again later."),
                  dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle(Text("Change App Icon"), displayMode: .inline)
    }

    func changeAppIcon(index: Int) {
        let iconName = iconSettings.iconNames[index]
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                print("App Icon Change Error Code: \((error as NSError).code)")
                showErrorAlert = true
            } else {
                print("Finished changing icon to \(iconName)")
                iconSettings.currentIndex = index
            }
        }
    }
}

struct IconPage_Previews: PreviewProvider {
    static var previews: some View {
        IconPage().environmentObject(IconNames())
    }
}
