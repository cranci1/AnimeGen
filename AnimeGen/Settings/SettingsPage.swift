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
    @State private var gestures = UserDefaults.standard.bool(forKey: "enableGestures")
    
    // API preferences
    @State private var tags = UserDefaults.standard.bool(forKey: "enableTags")
    @State private var moetags = UserDefaults.standard.bool(forKey: "enableMoeTags")
    @State private var kyokobanner = UserDefaults.standard.bool(forKey: "enableKyokobanner")
    
    // Content
    @State private var explicitCont = UserDefaults.standard.bool(forKey: "enableExplictiCont")
    
    // Devloper Mode
    @State private var developerMode = UserDefaults.standard.bool(forKey: "enableDeveloperMode")
    @State private var developerAlert = UserDefaults.standard.bool(forKey: "enableDeveloperAlert")
    
    // Tutorial
    @State private var isShowingTutorial = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Features"), footer: Text("An app restart is necessary to enable or disable the changes.")) {
                    Toggle("App Animations", isOn: Binding(
                        get: { self.animations },
                        set: { newValue in
                            self.animations = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableAnimations")
                        }
                    ))
                    Toggle("Background Gradient", isOn: Binding(
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
                    
                    Toggle("Enable Gestures", isOn: Binding(
                        get: { self.gestures },
                        set: { newValue in
                            self.gestures = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableGestures")
                        }
                    ))
                }
                
                Section(header: Text("Api Preferences"), footer: Text("An app restart is necessary to enable or disable the changes.")) {
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
                    Toggle("Kyoko 'Note' banner", isOn: Binding(
                        get: { self.kyokobanner },
                        set: { newValue in
                            self.kyokobanner = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableKyokobanner")
                        }
                    ))
                    
                }
                
                Section(header: Text("Content"), footer: Text("This content is on the borderline of explicit material and includes adult content. Viewer discretion is advised.")) {
                    Toggle("Explicit Contents", isOn: Binding(
                        get: { self.explicitCont },
                        set: { newValue in
                            self.explicitCont = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableExplictiCont")
                        }
                    ))
                }
                
                Section(header: Text("Developer")) {
                    
                    Toggle("Developer Mode", isOn: Binding(
                        get: { self.developerMode },
                        set: { newValue in
                            self.developerMode = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableDeveloperMode")
                        }
                    ))
        
                    Toggle("Developer Alert", isOn: Binding(
                        get: { self.developerAlert },
                        set: { newValue in
                            self.developerAlert = newValue
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
                
                Section(header: Text("About AnimeGen")) {
                    NavigationLink(destination: AboutPage()) {
                        Text("About")
                            .foregroundColor(.accentColor)
                    }
                    
                    NavigationLink(destination: ApiPage()) {
                        Text("APIs credits")
                            .foregroundColor(.accentColor)
                    }
                    
                    if #available(iOS 14.0, *) {
                        Button(action: {
                            isShowingTutorial = true
                        }) {
                            Text("Show Tutorial")
                                .foregroundColor(.accentColor)
                        }
                        .fullScreenCover(isPresented: $isShowingTutorial) {
                            TutorialView()
                        }
                    } else {
                        Button(action: {
                            isShowingTutorial = true
                        }) {
                            Text("Show Tutorial")
                                .foregroundColor(.accentColor)
                        }
                        .sheet(isPresented: $isShowingTutorial) {
                            TutorialView()
                        }
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsPage_Preview: PreviewProvider {
    static var previews: some View {
        SettingsPage()
            .preferredColorScheme(.dark)
    }
}
