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
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    CircularActivityIndicator()
                        .scaleEffect(1.5, anchor: .center)
                        .padding()

                } else {
                    List {
                        if let apiData = apiData {
                            ForEach(apiData.supported.sorted(by: { $0.key < $1.key }), id: \.key) { (key, value) in
                                HStack {
                                    Text(key)
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Image(systemName: value ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(value ? .green : .red)
                                        .scaleEffect(value ? 1.2 : 1.0)
                                        .transition(.scale)
                                }
                                .padding(.vertical, 4)
                            }
                        } else {
                            Text("No data available")
                                .foregroundColor(.gray)
                                .italic()
                        }
                    }
                    .animation(.default)
                    .overlay(
                        VStack {
                            Spacer()
                            Text("Support status will not be updated instantly, but rather promptly after the APIs resume operation.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .background(Color(UIColor.systemBackground).opacity(0.8))
                        }
                        .padding(.bottom, 20),
                        alignment: .bottom
                    )
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
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding()
            }
            .navigationBarTitle("APIs Status", displayMode: .inline)
            .onAppear {
                fetchData()
            }
        }
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
                
                #if !targetEnvironment(simulator)
                if #available(iOS 13.0, *) {
                    let iosVersion = ProcessInfo.processInfo.operatingSystemVersion
                    if iosVersion.majorVersion == 13 {
                        decodedData.supported["pic.re"] = false
                        decodedData.supported["Nekos api"] = false
                    }
                }
                #endif
                
                DispatchQueue.main.async {
                    self.apiData = decodedData
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        APIsSuppport()
    }
}
#endif


struct CircularActivityIndicator: View {
    var body: some View {
        #if os(iOS)
        if #available(iOS 14.0, *) {
            return AnyView(ProgressView())
        } else {
            return AnyView(ActivityIndicator(style: .large))
        }
        #else
        return AnyView(ActivityIndicator(style: .large))
        #endif
    }
}

#if os(iOS)
struct ActivityIndicator: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}
#endif
