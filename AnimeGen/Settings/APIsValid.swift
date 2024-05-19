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

struct APIsSupport: View {
    @State private var apiData: APIData? = nil
    @State private var isLoading: Bool = false
    @State private var fetchError: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    if #available(iOS 14.0, *) {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        ActivityIndicator(isAnimating: $isLoading, style: .large)
                            .padding()
                    }
                } else if fetchError {
                    Text("Failed to load data. Please try again.")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    if #available(iOS 14.0, *) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(apiData?.supported.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { (key, value) in
                                VStack {
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
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .shadow(radius: 4)
                            }
                        }
                        .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(0..<(apiData?.supported.count ?? 0) / 2 + 1, id: \.self) { rowIndex in
                                    HStack(spacing: 16) {
                                        ForEach(0..<2) { columnIndex in
                                            let index = rowIndex * 2 + columnIndex
                                            if index < (apiData?.supported.count ?? 0) {
                                                let api = apiData!.supported.sorted(by: { $0.key < $1.key })[index]
                                                VStack {
                                                    Text(api.key)
                                                    Spacer()
                                                    if api.value {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(.green)
                                                    } else {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .foregroundColor(.red)
                                                    }
                                                }
                                                .padding()
                                                .background(Color(.systemGray6))
                                                .cornerRadius(12)
                                                .shadow(radius: 4)
                                            } else {
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                
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
            .navigationBarTitle("APIs Status", displayMode: .inline)
        }
    }
    
    private func fetchData() {
        isLoading = true
        fetchError = false
        
        guard let url = URL(string: "https://raw.githubusercontent.com/cranci1/cranci.xyz-Astro/master/public/ValidAPI.json") else {
            print("Invalid URL")
            fetchError = true
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print("Error fetching data: \(error)")
                }
                DispatchQueue.main.async {
                    self.fetchError = true
                    self.isLoading = false
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
                    self.isLoading = false
                }
            } catch {
                print("Error decoding JSON: \(error)")
                DispatchQueue.main.async {
                    self.fetchError = true
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        APIsSupport()
    }
}
#endif
