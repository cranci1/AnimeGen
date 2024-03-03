//
//  LicensePage.swift
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
                Section(header: Text("App info"), footer: Text("AnimeGen is a free, open source iOS app, developed by cranci. The app is under the GNU General Public License version 3.")) {

                    HStack {
                        Text("Version: \(appVersion)")
                    }
                    
                    HStack {
                        Text("Build: \(appBuild)")
                    }
                    
                    HStack {
                        Text("Github Repository")
                    }
                    .font(.system(size: 15, weight: .regular))
                    .onTapGesture {
                        if let url = URL(string: "https://github.com/cranci1/AnimeGen/") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    HStack {
                        Text("Report an Issue")
                    }
                    .onTapGesture {
                        if let url = URL(string: "https://github.com/cranci1/AnimeGen/issues") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                
                Section(header: Text("Privacy"), footer: Text("AnimeGen prioritizes user privacy and does not store any personal data. All generated images are not retained by the app. If a user chooses to save an image, it will only be stored locally in their device's gallery exept for the Hmtai API. We are committed to ensuring a secure and private experience for our users.")) {
                    
                    HStack {
                        Text("Review the code")
                    }
                    .onTapGesture {
                        if let url = URL(string: "https://github.com/cranci1/AnimeGen/tree/main") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    HStack {
                        Text("Hmtai API Privacy")
                    }
                    .onTapGesture {
                        if let url = URL(string: "https://github.com/cranci1/AnimeGen/Privacy/Hmtai.md") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationBarTitle("About", displayMode: .inline)
    }
}

struct AboutPage_Previews: PreviewProvider {
    static var previews: some View {
        AboutPage()
    }
}
