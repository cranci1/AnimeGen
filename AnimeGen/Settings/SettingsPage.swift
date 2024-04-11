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
    @State private var gradient = UserDefaults.standard.bool(forKey: "enablegradient")
    @State private var activitytime = UserDefaults.standard.bool(forKey: "enableTime")
    
    // Tags
    @State private var tags = UserDefaults.standard.bool(forKey: "enableTags")
    @State private var moetags = UserDefaults.standard.bool(forKey: "enableMoeTags")
    
    // Content
    @State private var explicitCont = UserDefaults.standard.bool(forKey: "enableExplictiCont")
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Features"), footer: Text("An app restart is necessary for the gradient and activity label to take effect.")) {
                    Toggle("Use Animations", isOn: Binding(
                        get: { self.animations },
                        set: { newValue in
                            self.animations = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableAnimations")
                        }
                    ))
                    Toggle("Use Background Gradient", isOn: Binding(
                        get: { self.gradient },
                        set: { newValue in
                            self.gradient = newValue
                            UserDefaults.standard.set(newValue, forKey: "enablegradient")
                        }
                    ))
                    
                    Toggle("Display Activity Label", isOn: Binding(
                        get: { self.activitytime },
                        set: { newValue in
                            self.activitytime = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableTime")
                        }
                    ))
                }
                 
                
                Section(header: Text("Tags"), footer: Text("An app restart is necessary to enable or disable the changes.")) {
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
                            .foregroundColor(.accentColor)
                    }
                    
                    NavigationLink(destination: ApiPage()) {
                        Text("APIs credits")
                            .foregroundColor(.accentColor)
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
            .preferredColorScheme(.dark)
    }
}
