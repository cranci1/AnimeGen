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
                        HStack {
                            Image(systemName: "gear")
                            Text("APIs Preferences")
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    NavigationLink(destination: Features()) {
                        HStack {
                            Image(systemName: "square.grid.2x2")
                            Text("App Features")
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    NavigationLink(destination: Contents()) {
                        HStack {
                            Image(systemName: "doc.text.magnifyingglass")
                            Text("Contents Settings")
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    
                    NavigationLink(destination: HistoryPref()) {
                        HStack {
                            Image(systemName: "clock")
                            Text("History Settings")
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    NavigationLink(destination: DeveloperPref()) {
                        HStack {
                            Image(systemName: "hammer")
                            Text("Developer Preferences")
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                }
                                
                Section(header: Text("About AnimeGen")) {
                    NavigationLink(destination: AboutPage()) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("About")
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    NavigationLink(destination: ApiPage()) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("APIs Credits")
                                .foregroundColor(.accentColor)
                        }
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
