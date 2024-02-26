//
//  apicredit.swift
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
        APIInfo(imageName: "nekos.best", apiName: "nekos.best", url: URL(string: "https://nekos.best")!),
        APIInfo(imageName: "Hmtai", apiName: "Hmtai", url: URL(string: "https://hmtai.hatsunia.cfd/endpoints")!),
        APIInfo(imageName: "nekosapi", apiName: "nekosapi.com", url: URL(string: "https://nekosapi.com")!),
        APIInfo(imageName: "nekos.moe", apiName: "nekos.moe", url: URL(string: "https://nekos.moe")!)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(0..<apiData.count, id: \.self) { index in
                        if index % 3 == 0 {
                            HStack(spacing: 20) {
                                apiItem(index: index)
                                if index + 1 < apiData.count {
                                    apiItem(index: index + 1)
                                }
                                if index + 2 < apiData.count {
                                    apiItem(index: index + 2)
                                }
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 30, trailing: 10))
                .navigationBarHidden(true)
            }
        }
    }

    private func apiItem(index: Int) -> some View {
        let data = apiData[index]

        return Button(action: {
            openURL(data.url)
        }) {
            VStack {
                Image(data.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                    .cornerRadius(10)

                Text(data.apiName)
                    .padding(.top, 5)
                    .font(.headline)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

struct ApiPage_Preview: PreviewProvider {
    static var previews: some View {
        ApiPage()
    }
}
