//
//  waifu-it-pref.swift
//  AnimeGen
//
//  Created by cranci on 25/04/24.
//

import SwiftUI

struct waifuitView: View {
    @State private var waifuittoken: String

    
    init() {
        _waifuittoken = State(initialValue: UserDefaults.standard.string(forKey: "waifuItToken") ?? Secrets.waifuItToken)
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Waifu.it Preferences")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("API Token", text: $waifuittoken)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                Text("Enter your Waifu.it API token.")
                    .font(.caption)
                    .padding(.top, -10)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationBarHidden(true)
            
            Button(action: {
                saveValues2()
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accentColor)
                            .shadow(radius: 5)
                    )
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Waifu.it Settings", displayMode: .inline)
        
    }
    
    private func saveValues2() {
        UserDefaults.standard.set(waifuittoken, forKey: "waifuItToken")
        Secrets.waifuItToken = waifuittoken
    }
}

struct waifuitView_Previews: PreviewProvider {
    static var previews: some View {
        waifuitView()
    }
}
