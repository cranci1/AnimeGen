//
//  IconPage.swift
//  AnimeGen
//
//  Created by cranci on 28/02/24.
//

import SwiftUI

class IconNames: ObservableObject {
    var iconNames: [String?] = [nil]
    @Published var currentIndex = 0

    init() {
        getAlternateIcons()
        if let currentIcon = UIApplication.shared.alternateIconName {
            self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }
    }

    func getAlternateIcons() {
        if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
           let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] {

            for (_, value) in alternateIcons {
                guard let iconList = value as? Dictionary<String, Any> else { return }
                guard let iconFiles = iconList["CFBundleIconFiles"] as? [String] else { return }

                guard let icon = iconFiles.first else { return }

                iconNames.append(icon)
            }
        }
    }
}

struct IconPage: View {
    @EnvironmentObject var iconSettings: IconNames

    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< iconSettings.iconNames.count) { i in
                    Button(action: {
                        self.iconSettings.currentIndex = i
                        self.changeAppIcon()
                    }) {
                        HStack {
                            Image(uiImage: UIImage(named: self.iconSettings.iconNames[i] ?? "AppIcon") ?? UIImage())
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))

                            Text(self.iconSettings.iconNames[i] ?? "Base")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .lineLimit(1)
                                .padding(.leading, 8)

                            Spacer()
                        }
                    }
                }
            }
        }
    }

    func changeAppIcon() {
        let iconName = self.iconSettings.iconNames[self.iconSettings.currentIndex]
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                    print("App Icon Change Error Code: \((error as NSError).code)")
                } else {
                print("Finished changing icon to \(iconName ?? "AppIcon")")
            }
        }
    }
}

struct IconPage_Previews: PreviewProvider {
    static var previews: some View {
        IconPage().preferredColorScheme(.dark).environmentObject(IconNames())
    }
}
