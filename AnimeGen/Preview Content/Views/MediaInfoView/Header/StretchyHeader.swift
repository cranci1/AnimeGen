//
//  StretchyHeader.swift
//  Sora
//
//  Created by Francesco on 07/08/25.
//

import SwiftUI
import Nuke
import NukeUI

struct StretchyHeaderView: View {
    let backdropURL: String?
    let headerHeight: CGFloat
    let minHeaderHeight: CGFloat
    
    @State private var localAmbientColor: Color = Color.black
    @State private var backdropImage: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .global)
            let deltaY = frame.minY
            let height = headerHeight + max(0, deltaY)
            let offset = min(0, -deltaY)
            
            ZStack(alignment: .bottom) {
                Color.clear
                    .overlay(
                        LazyImage(url: URL(string: backdropURL ?? "")) { state in
                            if let image = state.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                            }
                        }
                            .onCompletion { result in
                                if case .success(let response) = result {
                                    let uiImage = response.image
                                    backdropImage = uiImage
                                }
                            },
                        alignment: .center
                    )
                    .clipped()
                    .frame(height: height)
                    .offset(y: offset)
            }
        }
        .frame(height: headerHeight)
    }
}
