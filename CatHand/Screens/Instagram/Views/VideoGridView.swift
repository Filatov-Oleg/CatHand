//
//  VideoGridView.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 03.12.2023.
//

import SwiftUI

struct VideoGridView: View {
    @Binding var savedVideos: [ImageAsset]
    @Binding var carouselType: СarouselImagesType
    @Binding var isShowCarouselImages: Bool
    @Binding var savedImagesIndex: Int
    @Binding var draggingItem: ImageAsset?
    
    @State private var heightCell: CGFloat = 0
    
    var body: some View {
        VStack {
            let colums = Array(repeating: GridItem(spacing: 1), count: 3)
            LazyVGrid(columns: colums, spacing: 1) {
                ForEach(savedVideos) { image in
                    GeometryReader {
                        let size = $0.size
                        Button {
                            carouselType = .video
                            isShowCarouselImages.toggle()
                            savedImagesIndex = savedVideos.firstIndex(of: image) ?? -1
                        } label: {
                            ZStack {
                                if let thumbnail = image.thumbnail {
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: size.width, height: size.width * 1.8)
                                        .clipped()
                                } else {
                                    RoundedRectangle(cornerRadius: 1)
                                        .fill(.blue)
                                }

                            }
                        }
                        .onAppear{
                            heightCell = size.width * 1.8
                        }
                        /// Drag
                        .draggable(image) {
                            /// Custom Preview View
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.ultraThinMaterial)
                                .frame(width: size.width, height: size.width * 1.8)
                                .frame(width: 1, height: 1)
                                .onAppear {
                                    draggingItem = image
                                }
                        }
                        /// Drop
                        .dropDestination(for: ImageAsset.self) { items, location in
                            draggingItem = nil
                            return false
                        } isTargeted: { status in
                            if let draggingItem, status, draggingItem != image {
                                /// Moving Color from source destination
                                if let sourceIndex = savedVideos.firstIndex(of: draggingItem),
                                   let destinationIndex = savedVideos.firstIndex(of: image) {
                                    withAnimation(.linear) {
                                        let sourceItem = savedVideos.remove(at: sourceIndex)
                                        savedVideos.insert(sourceItem, at: destinationIndex)
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: heightCell)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 15)
    }
}

//#Preview {
//    VideoGridView()
//}
