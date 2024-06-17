//
//  APIsValid.swift
//  AnimeGen
//
//  Created by cranci on 11/05/24.
//

import SwiftUI

struct APIData: Codable {
    var supported: [String: Bool]
}

struct APIsSuppport: View {
    @State private var apiData: APIData? = nil
    
    var body: some View {
        VStack {
            List {
                ForEach(apiData?.supported.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { (key, value) in
                    HStack {
                        Text(key)
                        Spacer()
                        if value {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .overlay(
                Text("Support status will not be updated instantly, but rather after I/users notice it.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.all, 18)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.secondary.opacity(0.1)),
                alignment: .bottom
            )
            Button(action: {
                withAnimation {
                    fetchData()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .foregroundColor(.white)
                        .font(.title)
                    Text("Refresh")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding()
                .background(Color("AccentColor"))
                .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            fetchData()
        }
        .navigationBarTitle("APIs Status")
    }
    
    private func fetchData() {
        guard let url = URL(string: "https://raw.githubusercontent.com/cranci1/cranci.xyz-Astro/master/public/ValidAPI.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print("Error fetching data: \(error)")
                }
                return
            }
            
            do {
                var decodedData = try JSONDecoder().decode(APIData.self, from: data)
                
                let iosVersion = UIDevice.current.systemVersion
                if iosVersion.starts(with: "13") {
                    decodedData.supported["pic.re"] = false
                    decodedData.supported["Nekos api"] = false
                }
                
                DispatchQueue.main.async {
                    self.apiData = decodedData
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        APIsSuppport()
    }
}
