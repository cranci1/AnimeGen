//
//  ApiPage.swift
//  AnimeGen
//
//  Created by cranci on 25/02/24.
//

import SwiftUI

struct ApiPage: View {
    struct APIInfo: Hashable {
        let imageName: String
        let apiName: String
        let url: URL
    }

    let apiData: [APIInfo] = [
        APIInfo(imageName: "pic-re", apiName: "pic.re", url: URL(string: "https://pic.re")!),
        APIInfo(imageName: "waifu.im", apiName: "waifu.im", url: URL(string: "https://waifu.im")!),
        APIInfo(imageName: "waifu.pics", apiName: "waifu.pics", url: URL(string: "https://waifu.pics")!),
        APIInfo(imageName: "waifu.it", apiName: "waifu.it", url: URL(string: "https://waifu.it/")!),
        APIInfo(imageName: "nekos.best", apiName: "nekos.best", url: URL(string: "https://nekos.best")!),
        APIInfo(imageName: "nekosapi", apiName: "nekosapi.com", url: URL(string: "https://nekosapi.com")!),
        APIInfo(imageName: "nekos.moe", apiName: "nekos.moe", url: URL(string: "https://nekos.moe")!),
        APIInfo(imageName: "Hmtai", apiName: "Hmtai", url: URL(string: "https://hmtai.hatsunia.cfd/endpoints")!),
        APIInfo(imageName: "kyoko", apiName: "Kyoko", url: URL(string: "https://api.rei.my.id/docs/ANIME/WAIFU-Generator/")!),
        APIInfo(imageName: "Purr", apiName: "Purr", url: URL(string: "https://purrbot.site/")!)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(Array(apiData.enumerated()), id: \.element.self) { index, data in
                        if index != apiData.count - 1 {
                            APIRow(data: data)
                        } else {
                            VStack(spacing: 10) {
                                APIRow(data: data)
                                THanksSection()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .navigationBarTitle("APIs Credit", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct THanksSection: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Special Thanks")
                .font(.title)
                .fontWeight(.bold)
            Text("Special thanks to all the developers who provided these APIs for public use. Without them, this project wouldn't exist. Thank you very much!")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}

struct APIRow: View {
    let data: ApiPage.APIInfo
    
    var body: some View {
        HStack {
            Image(data.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .onTapGesture {
                    openURL(data.url)
                }
            
            VStack(alignment: .leading) {
                Text(data.apiName)
                    .font(.title)
                    .foregroundColor(.accentColor)
                    .padding(.vertical, 10)
                    .onTapGesture {
                        openURL(data.url)
                    }
            }
            .padding(.horizontal, 10)
            Spacer()
        }
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

struct ApiPage_Preview: PreviewProvider {
    static var previews: some View {
        ApiPage()
            .preferredColorScheme(.dark)
    }
}
