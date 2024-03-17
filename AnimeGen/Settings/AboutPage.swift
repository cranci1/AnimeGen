//
//  AboutPage.swift
//  AnimeGen
//
//  Created by cranci on 18/02/24.
//

import SwiftUI

struct AboutPage: View {
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("App info"),
                        footer: Text("AnimeGen is a free, open source iOS app, developed by cranci. The app is under the GNU General Public License version 3.")) {
                    InfoRow(title: "Version", value: appVersion)
                    InfoRow(title: "Build", value: appBuild)
                    LinkRow(title: "Github Repository", url: "https://github.com/cranci1/AnimeGen/")
                    LinkRow(title: "Report an Issue", url: "https://github.com/cranci1/AnimeGen/issues")
                }
                
                Section(header: Text("Privacy"),
                        footer: Text("AnimeGen prioritizes user privacy and does not store any personal data. All generated images are not retained by the app. If a user chooses to save an image, it will only be stored locally in their device's gallery except for the Hmtai API. We are committed to ensuring a secure and private experience for our users.")) {
                    LinkRow(title: "Review the code", url: "https://github.com/cranci1/AnimeGen/tree/main")
                    LinkRow(title: "Hmtai API Privacy", url: "https://github.com/cranci1/AnimeGen/blob/main/Privacy/Hmtai.md")
                }
                
                Section(header: Text("License"),
                        footer: Text("""
                                    Copyright © 2023-2024 cranci. All rights reserved.

                                    AnimeGen is free software: you can redistribute it and/or modify
                                    it under the terms of the GNU General Public License as published by
                                    the Free Software Foundation, either version 3 of the License, or
                                    (at your option) any later version.

                                    AnimeGen is distributed in the hope that it will be useful,
                                    but WITHOUT ANY WARRANTY; without even the implied warranty of
                                    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                    GNU General Public License for more details.

                                    You should have received a copy of the GNU General Public License
                                    along with AnimeGen.  If not, see <http://www.gnu.org/licenses/>.
                                    """)) {
                    LinkRow(title: "Full License", url: "https://github.com/cranci1/AnimeGen/blob/main/LICENSE")
                }
            }
            .navigationBarHidden(true)
        }
        .navigationBarTitle("About", displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                                }) {
                                    Text("Close")
                                }
                            )
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text("\(title): \(value)")
        }
    }
}

struct LinkRow: View {
    let title: String
    let url: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.accentColor)
                .onTapGesture {
                    if let url = URL(string: self.url) {
                        UIApplication.shared.open(url)
                    }
                }
            Image(systemName: "arrow.right.circle.fill")
                .foregroundColor(.accentColor)
                .onTapGesture {
                    if let url = URL(string: self.url) {
                        UIApplication.shared.open(url)
                    }
                }
        }
    }
}

struct AboutPage_Previews: PreviewProvider {
    static var previews: some View {
        AboutPage()
            .preferredColorScheme(.dark)
    }
}
