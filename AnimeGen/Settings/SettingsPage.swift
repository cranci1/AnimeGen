//
//  SettingsPage.swift
//  AnimeGen
//
//  Created by cranci on 18/02/24.
//

import SwiftUI

struct SettingsPage: View {
    
    // Tutorial
    @State private var isShowingTutorial = false
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("App Settings"), footer: Text("You can access different app settings on these pages.")) {
                    NavigationLink(destination: APIPreferences()) {
                        Text("APIs Preferences")
                            .foregroundColor(.accentColor)
                    }
                    
                    NavigationLink(destination: Features()) {
                        Text("App Features")
                            .foregroundColor(.accentColor)
                    }
                    
                    NavigationLink(destination: Contents()) {
                        Text("Contents Settings")
                            .foregroundColor(.accentColor)
                    }
                    
                    
                    NavigationLink(destination: HistoryPref()) {
                        Text("History Settings")
                            .foregroundColor(.accentColor)
                    }
                    
                    NavigationLink(destination: DeveloperPref()) {
                        Text("Developer Preferences")
                            .foregroundColor(.accentColor)
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
