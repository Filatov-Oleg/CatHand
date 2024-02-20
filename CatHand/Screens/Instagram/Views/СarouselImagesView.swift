//
//  СarouselImagesView.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 23.11.2023.
//

import SwiftUI
import PhotosUI



enum СarouselImagesType {
    case profile
    case story
    case image
    case video
}

struct СarouselImagesView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var instagramViewModel: InstagramViewModel
    
    @State var selectedImage: Int = 0
    
    @Binding var selectedDetent: PresentationDetent
    
    @State var showCamera: Bool = false
    
    //    @Binding var isPresented: Bool
    
    //    init(instagramViewModel: InstagramViewModel, isPresented: Binding<Bool>) {
    //        self.instagramViewModel = instagramViewModel
    //        self._isPresented = isPresented
    //    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let pageWidth: CGFloat = size.width / 4
            let imageWidth: CGFloat = 80
            VStack {
                Spacer()
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 3.5)
                        .frame(width: 60, height: 7)
                        .foregroundStyle(Color(uiColor: UIColor(hexString: "4C4B4B")))
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
//                            Button {
//                                print("Open library")
//                            } label: {
//                                ZStack {
//                                    Image(uiImage: UIImage(named: "BackgroundImage")!)
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: imageWidth, height: imageWidth)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                                    Image(systemName: "plus")
//                                }
//                                .frame(width: pageWidth, height: size.height * 0.7)
//                            }
                            ForEach($instagramViewModel.fetchedImages) { $imageAsset in
                                let isLast = instagramViewModel.fetchedImages.isLastElement(imageAsset)
                                ZStack {
                                    if let thumbnail = imageAsset.thumbnail {
                                        Image(uiImage: thumbnail)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: imageWidth, height: imageWidth)
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    } else {
                                        ProgressView()
                                            .frame(width: imageWidth, height: size.height)
                                    }
                                }
                                .frame(width: pageWidth, height: size.height * 0.7) // отступ между фотками
                                .onAppear {
                                    if imageAsset.thumbnail == nil {
                                        // MARK: Fetching thumbnail image
                                        let manager = PHCachingImageManager.default()
                                        manager.requestImage(for: imageAsset.asset ?? PHAsset(), targetSize: CGSize(width: size.width, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
                                            imageAsset.thumbnail = image
                                        }
                                    }
                                    if isLast {
                                        instagramViewModel.fetchNextImages()
                                    }
                                }
                                .onChange(of: selectedImage) { newValue in
                                    switch instagramViewModel.carouselType {
                                    case .profile:
                                        instagramViewModel.profileImage = instagramViewModel.fetchedImages[newValue].thumbnail
                                    case .story:
                                        instagramViewModel.storyImages[instagramViewModel.savedImagesIndex].thumbnail =
                                        instagramViewModel.fetchedImages[newValue].thumbnail
                                    case .image:
                                        instagramViewModel.savedPosts[instagramViewModel.savedImagesIndex].thumbnail = instagramViewModel.fetchedImages[newValue].thumbnail
                                    case .video:
                                        instagramViewModel.savedVideos[instagramViewModel.savedImagesIndex].thumbnail = instagramViewModel.fetchedImages[newValue].thumbnail
                                    @unknown default:
                                        print("DEFAULT CAROUSEL")
                                    }
                                    
                                    //                            imageCell = imagePickerModel.fetchedImages[newValue].thumbnail!
                                }
                            }
                        }
                        /// Making to start from the center
                        .padding(.horizontal, (size.width - pageWidth) / 2)
                        .background {
                            ImageCarouselHelper(pageWidth: pageWidth, pageCount: instagramViewModel.fetchedImages.count, index: $selectedImage)
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.mainGradientBackground, lineWidth: 3.5)
                            .frame(width: imageWidth, height: imageWidth)
                        /// Disabling user interaction's
                            .allowsTightening(false)
                    }
                    .padding(.horizontal, 1.5)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Button {
                                withAnimation {
                                    instagramViewModel.deleteItemImage()
                                    dismiss()
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.caption2)
                                    Text("Удалить")
                                        .font(.caption2)
                                }
                                .foregroundStyle(Color.white)
                                .padding(4)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(.white, lineWidth: 1)
                                }
                            }
                            
//                            Button {
//                                print("Камера")
////                                showCamera.toggle()
//                            } label: {
//                                HStack {
//                                    Image(systemName: "camera")
//                                        .font(.caption2)
//                                    Text("Камера")
//                                        .font(.caption2)
//                                }
//                                .foregroundStyle(Color.white)
//                                .padding(4)
//                                .overlay {
//                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
//                                        .stroke(.white, lineWidth: 1)
//                                }
//                            }
                            Spacer()
                        }
                        .padding(.leading, 24)
                        .padding(.vertical, 2)
                    }
                    .padding(.bottom, 8)
                }
                .frame(height: 165)
                .padding(.bottom, 16)
                .background(Color(uiColor: UIColor(hexString: "4C4B4B")))
                .cornerRadius(16, corners: .topLeft)
                .cornerRadius(16, corners: .topRight)
            }
            .padding(.bottom, -35)
        }
        .background(BackgroundClearView())
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.height > 0 {
                    dismiss()
                }
            }))
        .fullScreenCover(isPresented: $showCamera) {
            CameraImage(sourceType: .camera, selectedImage: $instagramViewModel.savedPosts[instagramViewModel.savedImagesIndex].thumbnail)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        //        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
