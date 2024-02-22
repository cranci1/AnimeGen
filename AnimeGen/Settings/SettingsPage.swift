//
//  File.swift
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
                    Toggle("Use Animations", isOn: Binding(
                        get: { self.animations },
                        set: { newValue in
                            self.animations = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableAnimations")
                        }
                    ))
                    Toggle("Display Tags", isOn: Binding(
                        get: { self.tags },
                        set: { newValue in
                            self.tags = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableTags")
                        }
                    ))
                    Toggle("Display nekos.moe Tags", isOn: Binding(
                        get: { self.moetags },
                        set: { newValue in
                            self.moetags = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableMoeTags")
                        }
                    ))
                }
                
                Section(header: Text("Content"), footer: Text("Caution: This content is on the borderline of explicit material and includes adult content. Viewer discretion is advised.")) {
                    
                    Toggle("Suggestive Contents", isOn: Binding(
                        get: { self.suggestiveCont },
                        set: { newValue in
                            self.suggestiveCont = newValue
                            UserDefaults.standard.set(newValue, forKey: "enablesuggestiveCont")
                        }
                    ))
                    
                    Toggle("Borderline Contents", isOn: Binding(
                        get: { self.borderlineCont },
                        set: { newValue in
                            self.borderlineCont = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableBorderlineCont")
                        }
                    ))

                    Toggle("Explicit Contents", isOn: Binding(
                        get: { self.explicitCont },
                        set: { newValue in
                            self.explicitCont = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableExplictiCont")
                        }
                    ))
                }
                                
                Section(header: Text("About AnimeGen")) {
                    NavigationLink(destination: AboutPage()) {
                        Text("About")
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsPage_Preview: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
