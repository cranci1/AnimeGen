//
//  History.swift
//  AnimeGen
//
//  Created by cranci on 30/04/24.
//

import SwiftUI

struct HistoryPref: View {
    
    // Content
    @State private var historyOvertime = UserDefaults.standard.bool(forKey: "enableHistoryOvertime")
    @State private var showAlert = false
        
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("'Don't clear history': It makes so that the history will not be cleared when closing the app.")) {
                    Toggle("Don't clear history", isOn: Binding(
                        get: { self.historyOvertime },
                        set: { newValue in
                            self.historyOvertime = newValue
                            UserDefaults.standard.set(newValue, forKey: "enableHistoryOvertime")
                        }
                    ))
                }
                
                Section {
                     Button(action: {
                         showAlert = true
                     }) {
                         HStack {
                             Image(systemName: "trash")
                             Text("Clear History")
                         }
                         .foregroundColor(.red)
                     }
                 }
             }
             .navigationBarHidden(true)
             .alert(isPresented: $showAlert) {
                 Alert(
                     title: Text("Are you sure?"),
                     message: Text("This action will clear all history. Are you sure you want to proceed?"),
                     primaryButton: .default(Text("Cancel")),
                     secondaryButton: .destructive(Text("Clear"), action: clearHistory)
                 )
             }
         }
         .navigationBarTitle("History Settings", displayMode: .inline)
         .navigationViewStyle(StackNavigationViewStyle())
     }
     
     private func clearHistory() {
         UserDefaults.standard.removeObject(forKey: "imageHistory")
     }
 }

 struct HistoryPrefPage_Preview: PreviewProvider {
     static var previews: some View {
         HistoryPref()
             .preferredColorScheme(.dark)
     }
 }
