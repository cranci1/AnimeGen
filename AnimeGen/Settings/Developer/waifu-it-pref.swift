//
//  waifu-it-pref.swift
//  AnimeGen
//
//  Created by cranci on 25/04/24.
//

import SwiftUI

struct waifuitView: View {
    @State private var waifuittoken: String
    @ObservedObject var viewController = ViewController()

    init() {
        _waifuittoken = State(initialValue: UserDefaults.standard.string(forKey: "waifuItToken") ?? Secrets.waifuItToken)
    }
    
    var body: some View {
        VStack {
            
            Stepper(value: $viewController.widthMultiplier, in: 0...2, step: 0.1) {
                Text("Width Multiplier: \(viewController.widthMultiplier, specifier: "%.2f")")
            }
            .padding()

            Stepper(value: $viewController.heightMultiplier, in: 0...2, step: 0.1) {
                Text("Height Multiplier: \(viewController.heightMultiplier, specifier: "%.2f")")
            }
            .padding()

            VStack(spacing: 20) {                
                TextField("API Token", text: $waifuittoken)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                Text("Enter your Waifu.it API token.")
                    .font(.caption)
                    .padding(.top, -10)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
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
        .navigationBarTitle("Waifu.it Settings")
        
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
