//
//  Content.swift
//  AnimeGen
//
//  Created by cranci on 30/04/24.
//

import SwiftUI

struct Contents: View {
    
    // Content
    @State private var explicitCont = UserDefaults.standard.bool(forKey: "enableExplictiCont")
    @State private var showAlert = false
        
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("""
                                    This content is on the borderline of explicit material and includes adult content. Viewer discretion is advised.
                                    """)) {

                    Toggle("Explicit Contents", isOn: Binding(
                        get: { self.explicitCont },
                        set: { newValue in
                            if newValue {
                                showAlert = true
                            } else {
                                self.explicitCont = newValue
                                UserDefaults.standard.set(newValue, forKey: "enableExplictiCont")
                            }
                        }
                    ))
                    
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("Enabling explicit content may not be suitable for all audiences. Are you sure you want to proceed?"),
                    primaryButton: .default(Text("Enable"), action: {
                        self.explicitCont = true
                        UserDefaults.standard.set(true, forKey: "enableExplictiCont")
                    }),
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
        .navigationBarTitle("Contents Settings", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentPage_Preview: PreviewProvider {
    static var previews: some View {
        Contents()
            .preferredColorScheme(.dark)
    }
}
