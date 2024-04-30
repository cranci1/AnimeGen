//
//  API-Pref.swift
//  AnimeGen
//
//  Created by cranci on 30/04/24.
//

import SwiftUI

struct APIPreferences: View {
    
    // API preferences
    @State private var loadstart = UserDefaults.standard.bool(forKey: "enableImageStartup")
    @State private var tags = UserDefaults.standard.bool(forKey: "enableTags")
    @State private var moetags = UserDefaults.standard.bool(forKey: "enableMoeTags")
    @State private var kyokobanner = UserDefaults.standard.bool(forKey: "enableKyokobanner")
    
    // Default API
    @State private var isPresentingActionSheet = false
    @State private var selectedChoiceIndex = UserDefaults.standard.integer(forKey: "SelectedChoiceIndex")
    
    let choices = ["waifu.im", "pic.re", "waifu.pics", "waifu.it", "nekos.best", "Nekos api", "nekos.moe", "NekoBot", "kyoko", "Purr"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("""
                                    Default API Selection: You can customize your preferred API that the app will utilize upon opening. (Only works when opening the App)
                                    
                                    Load Image on Startup: You can choose whether to generate an image when the app starts or not.
                                    
                                    Display of Tags: You have control over whether to display tags associated with each image.
                                    
                                    Display nekos.moe Tags: You can choose whether to show or hide tags sourced from the nekos.moe API. (App Restart is required)
                                    
                                    Kyoko 'Note' Banner: You'll be notified with a special banner for the Kyoko API since it's very slow. (App Restart is required)
                                    """)) {
                    Button(action: {
                        isPresentingActionSheet = true
                    }) {
                        HStack {
                            Text("Default API")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(choices[selectedChoiceIndex])
                                .foregroundColor(.accentColor)
                        }
                    }
                    .actionSheet(isPresented: $isPresentingActionSheet) {
                        ActionSheet(title: Text("Choose Default API"), buttons: [
                            .default(Text("Purr")) { updateSelectedChoiceIndex(9) },
                            .default(Text("kyoko")) { updateSelectedChoiceIndex(8) },
                            .default(Text("NekoBot")) { updateSelectedChoiceIndex(7) },
                            .default(Text("nekos.moe")) { updateSelectedChoiceIndex(6) },
                            .default(Text("Nekos api")) { updateSelectedChoiceIndex(5) },
                            .default(Text("nekos.best")) { updateSelectedChoiceIndex(4) },
                            .default(Text("waifu.it")) { updateSelectedChoiceIndex(3) },
                            .default(Text("waifu.pics")) { updateSelectedChoiceIndex(2) },
                            .default(Text("waifu.im")) { updateSelectedChoiceIndex(0) },
                            .default(Text("pic.re")) { updateSelectedChoiceIndex(1) },
                            .cancel()
                        ])
                    }
                    .onAppear {
                        selectedChoiceIndex = UserDefaults.standard.integer(forKey: "SelectedChoiceIndex")
                    }
                    .onDisappear {
                        UserDefaults.standard.set(selectedChoiceIndex, forKey: "SelectedChoiceIndex")
                        NotificationCenter.default.post(name: Notification.Name("SelectedChoiceChanged"), object: selectedChoiceIndex)
                    }
                    
                    Toggle("Load Image on Startup", isOn: Binding(
                        get: { self.loadstart },
                        set: { newValue in
                            self.loadstart = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableImageStartup")
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
                    Toggle("Kyoko 'Note' banner", isOn: Binding(
                        get: { self.kyokobanner },
                        set: { newValue in
                            self.kyokobanner = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableKyokobanner")
                        }
                    ))
                    
                }
            }
            .navigationBarHidden(true)
        }
        .navigationBarTitle("APIs Preferences", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func updateSelectedChoiceIndex(_ index: Int) {
        selectedChoiceIndex = index
        UserDefaults.standard.set(index, forKey: "SelectedChoiceIndex")
        NotificationCenter.default.post(name: Notification.Name("SelectedChoiceChanged"), object: index)
    }
    
}

struct APIPref_Preview: PreviewProvider {
    static var previews: some View {
        APIPreferences()
            .preferredColorScheme(.dark)
    }
}
