//
//  SettingsPage.swift
//  AnimeGen
//
//  Created by cranci on 18/02/24.
//

import SwiftUI

struct SettingsPage: View {
    
    // Features
    @State private var animations = UserDefaults.standard.bool(forKey: "enableAnimations")
    @State private var tags = UserDefaults.standard.bool(forKey: "enableTags")
    @State private var moetags = UserDefaults.standard.bool(forKey: "enableMoeTags")
    
    // Content
    @State private var suggestiveCont = UserDefaults.standard.bool(forKey: "enablesuggestiveCont")
    @State private var borderlineCont = UserDefaults.standard.bool(forKey: "enableBorderlineCont")
    @State private var explicitCont = UserDefaults.standard.bool(forKey: "enableExplictiCont")
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Features")) {
                    Toggle("Use Animations", isOn: $animations)
                    Toggle("Display Tags", isOn: $tags)
                    Toggle("Display nekos.moe Tags", isOn: $moetags)
                }
                
                Section(header: Text("Content"), footer: Text("Caution: This content is on the borderline of explicit material and includes adult content. Viewer discretion is advised.")) {
                    Toggle("Suggestive Contents", isOn: $suggestiveCont)
                    Toggle("Borderline Contents", isOn: $borderlineCont)
                    Toggle("Explicit Contents", isOn: $explicitCont)
                }
                
                Section(header: Text("About AnimeGen")) {
                    NavigationLink(destination: AboutPage()) {
                        Text("About")
                            .foregroundColor(.accentColor)
                    }
                    
                    NavigationLink(destination: ApiPage()) {
                        Text("APIs credits")
                            .foregroundColor(.accentColor)
                    }
                }
                
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                                    }) {
                                        Text("Close")
                                    }
            )
        }
    }
}

struct SettingsPage_Preview: PreviewProvider {
    static var previews: some View {
        SettingsPage()
            .preferredColorScheme(.dark)
    }
}
