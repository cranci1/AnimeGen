//
//  Developer.swift
//  AnimeGen
//
//  Created by cranci on 30/04/24.
//

import SwiftUI

struct DeveloperPref: View {
    
    // Devloper Mode
    @State private var developerMode = UserDefaults.standard.bool(forKey: "enableDeveloperMode")
    @State private var developerAlert = UserDefaults.standard.bool(forKey: "enableDeveloperAlert")
        
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("""
                                    Enabling 'Developer Mode' grants access to additional specific settings and beta modules.
                                    
                                    Enabling 'Developer Alerts' lets you view error messages explaining why an image failed to load.
                                    """)) {

                    Toggle("Developer Mode", isOn: Binding(
                        get: { UserDefaults.standard.bool(forKey: "enableDeveloperMode") },
                        set: { newValue in
                            UserDefaults.standard.set(newValue, forKey: "enableDeveloperMode")
                        }
                    ))
        
                    Toggle("Developer Alert", isOn: Binding(
                        get: { UserDefaults.standard.bool(forKey: "enableDeveloperAlert") },
                        set: { newValue in
                            UserDefaults.standard.set(newValue, forKey: "enableDeveloperAlert")
                        }
                    ))
                    
                    if UserDefaults.standard.bool(forKey: "enableDeveloperMode") {
                        NavigationLink(destination: DeveloperView()) {
                            Text("Hmtai Preferences")
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    if UserDefaults.standard.bool(forKey: "enableDeveloperMode") {
                        NavigationLink(destination: waifuitView()) {
                            Text("Waifu.it Preferences")
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                }
            }
            .navigationBarHidden(true)
        }
        .navigationBarTitle("Developer Preferences", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Developer_Preview: PreviewProvider {
    static var previews: some View {
        DeveloperPref()
            .preferredColorScheme(.dark)
    }
}
