//
//  PostsGridView.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 03.12.2023.
//

import SwiftUI

struct PostsGridView: View {
    
    @ObservedObject var viewModel: InstagramViewModel

    @Binding var isShowCarouselImages: Bool
    @State var draggingItem: ImageAsset?
    
    @State private var heightCell: CGFloat = 0
    
    var body: some View {
        VStack {
            let colums = Array(repeating: GridItem(spacing: 1), count: 3)
            LazyVGrid(columns: colums, spacing: 1) {
                ForEach(viewModel.savedPosts) { image in
                    GeometryReader {
                        let size = $0.size
                        Button {
                            viewModel.carouselType = .image
                            isShowCarouselImages.toggle()
                            viewModel.savedImagesIndex = viewModel.savedPosts.firstIndex(of: image) ?? -1
                            viewModel.deleteImageIndex = viewModel.savedImagesIndex
                        } label: {
                            ZStack {
                                if let thumbnail = image.thumbnail {
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: size.width, height: size.height)
                                        .clipped()
                                } else {
                                    RoundedRectangle(cornerRadius: 1)
                                        .fill(Color.mainGradientBackground)
                                }
                            }
                        }
                        .onAppear{
                           heightCell = size.width
                        }
    
                        /// Drag
                        .draggable(image) {
                            /// Custom Preview View
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.ultraThinMaterial)
                                .frame(width: size.width, height: size.height)
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
                                withAnimation(.linear) {
                                    viewModel.changePositionPost(draggingItem: draggingItem, image: image)
                                }
//                                if let sourceIndex = viewModel.savedPosts.firstIndex(of: draggingItem),
//                                   let destinationIndex = viewModel.savedPosts.firstIndex(of: image) {
//                                    withAnimation(.linear) {
//                                        let sourceItem = viewModel.savedPosts.remove(at: sourceIndex)
//                                        viewModel.savedPosts.insert(sourceItem, at: destinationIndex)
//                                    }
//                                }
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
