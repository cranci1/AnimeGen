//
//  Features.swift
//  AnimeGen
//
//  Created by cranci on 30/04/24.
//

import SwiftUI

struct Features: View {
    
    // Features
    @State private var animations = UserDefaults.standard.bool(forKey: "enableAnimations")
    @State private var gradient = UserDefaults.standard.bool(forKey: "enablegradient")
    @State private var activitytime = UserDefaults.standard.bool(forKey: "enableTime")
    @State private var gestures = UserDefaults.standard.bool(forKey: "enableGestures")
        
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("""
                                    App Animations: Choose to show or hide animations for:

                                        - New Image Generation
                                        - Previous Image
                                        - Save Image
                                    
                                    Background Gradient: Opt to show or hide a violet gradient background. (App Restart is required)

                                    Display Activity Label: Choose to show or hide an activity control label displaying session time and images generated. (App Restart is required)

                                    Enable Gestures: Enable to utilize app gestures: (App Restart is required)

                                        - Swipe Left to Right: Last Image
                                        - Swipe Right to Left: Generate New Image
                                        - Swipe Top to Bottom: Show Settings
                                    """)) {

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
            }
            .navigationBarHidden(true)
        }
        .navigationBarTitle("App Features", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Features_Preview: PreviewProvider {
    static var previews: some View {
        Features()
            .preferredColorScheme(.dark)
    }
}
