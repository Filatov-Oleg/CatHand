//
//  InstagramScreen.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 12.10.2023.
//

import SwiftUI
import PhotosUI


// MARK: Selected Image Asset Model


struct InstagramScreen: View {
    
    @StateObject var instagramViewModel: InstagramViewModel 
    
    @State private var draggingItem: ImageAsset?
    
    @State private var isShowCarouselImages: Bool = false
    @State private var isShowSettings: Bool = false
    @State private var isShowAlert: Bool = false
    
    @State var imageCell: UIImage? = UIImage(named: "catAnn")
    
    @State var savedImageIndex: Int = -1
    
    @State private var selectedTab: String = "square.grid.3x3"
    @Namespace var animation
    
    @State private var selectedDetent: PresentationDetent = .height(165)

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                switch instagramViewModel.currentState {
                case .loading:
                    Text("Loading...")
                case .content:
                    HStack(spacing: 15) {
                        Button {
                            print("Nickname")
                        } label: {
                            Text(instagramViewModel.userInfo?.nickName ?? "Nickname")
                                .foregroundStyle(Color("TextColor"))
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        Spacer(minLength: 0)
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "plus.app")
//                                .font(.title)
//                                .foregroundColor(.primary)
//                        }
                        Button {
                            isShowSettings.toggle()
                        } label: {
                            Image("SettingsIcon")
                        }
                        
                    }
                    .padding([.horizontal, .top])
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            Divider()
                            // Plus button
                            HStack {
                                Button {
                                    instagramViewModel.carouselType = .profile
                                    withAnimation {
                                        isShowCarouselImages.toggle()
                                    }
                                } label: {
                                    Image(uiImage: instagramViewModel.profileImage!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 75, height: 75)
                                        .clipShape(Circle())
                                        .overlay(alignment: .bottomTrailing) {
                                            Image(systemName: "plus")
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.white)
                                                .padding(6)
                                                .background(Color.blue)
                                                .clipShape(Circle())
                                                .padding(2)
                                                .background(Color.black)
                                                .clipShape(Circle())
                                                .offset(x: 5, y: 5)
                                        }
                                }
                                
                                VStack {
                                    Text("\(instagramViewModel.savedPosts.count)")
                                    //                                    .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    Text("Posts")
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack {
                                    Text(instagramViewModel.userInfo?.countOfFollowers ?? "-1")
                                    //                                    .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    Text("Followers")
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack {
                                    Text(instagramViewModel.userInfo?.countOfFollowings ?? "-1")
                                    //                                    .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    Text("Following")
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding()
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    if let user = instagramViewModel.userInfo {
                                        Text(user.name)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                        Text(user.aboutMe)
                                        if let url = URL(string: user.link) {
                                            Link(destination: url) {
                                                Label(user.link, systemImage: "link")
                                            }.foregroundStyle(Color.white)
                                        }
                                    }
                                }
                                .padding([.horizontal])
                                Spacer()
                            }
                            
                            // Stories sections
                            
                            StoriesView(viewModel: instagramViewModel, isShowCarouselImages: $isShowCarouselImages)

                            
                            HStack(spacing: 0) {
                                TabBarButton(image: "square.grid.3x3", isSystemImage: true, animation: animation, selectedTab: $selectedTab)
                                TabBarButton(image: "play.square", isSystemImage: true, animation: animation, selectedTab: $selectedTab)
                            }
                            .frame(height: 50, alignment: .bottom)
                            .background(Color.backgroundColor)
                            
                            // Posts grid view
                            
                            if selectedTab == "square.grid.3x3" {
                                PostsGridView(viewModel: instagramViewModel,
                                              isShowCarouselImages: $isShowCarouselImages)
                            } else {
                                VideoGridView(savedVideos: $instagramViewModel.savedVideos,
                                              carouselType: $instagramViewModel.carouselType,
                                              isShowCarouselImages: $isShowCarouselImages,
                                              savedImagesIndex: $instagramViewModel.savedImagesIndex,
                                              draggingItem: $draggingItem)
                            }
                            
                            
                            
                        }
                    }
                }
                
            }
            .background(Color.backgroundColor)
            .overlay(alignment: .bottomTrailing, content: {
                Button {
                    withAnimation {
                        instagramViewModel.addNewPost()
                    }
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.mainGradientBackground)
                        .frame(width: 55, height: 55, alignment: .center)
                        .background(.black.opacity(0.5), in: Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.mainGradientBackground, lineWidth: 1)
                        )
                        .opacity(instagramViewModel.currentState == .content ? 1 : 0)
                    //                    .background(.blue.shadow(.drop(color: .red.opacity(0.25), radius: 5, x: 7, y: 7)), in: Circle())
                }
                .padding(15)
                
            })
            .offset(y: (isShowCarouselImages && instagramViewModel.carouselType == .image) ? -165 : 0).animation(.easeInOut, value: isShowCarouselImages)
            .fullScreenCover(isPresented: $isShowCarouselImages) {
                СarouselImagesView(instagramViewModel: instagramViewModel, selectedDetent: $selectedDetent)
                    .onAppear {
                        instagramViewModel.fetchImages()
                    }
                    .onDisappear {
                        instagramViewModel.updateData()
                    }
                
            }
            .fullScreenCover(isPresented: $isShowSettings) {
                InstagramSettingsView(instagramViewModel: instagramViewModel) { userInfo in
                    instagramViewModel.updateUserInfo(by: userInfo)
                }.onDisappear {
                    isShowSettings = false
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if !(UserDefaultsService().needShowInstagramSettings ?? false) {
                        print("show settings view")
                        isShowSettings = true
                        UserDefaultsService().needShowInstagramSettings = true
                    } else {
                        instagramViewModel.fetchAllImages()
                    }
                }
            }
            .task {
                instagramViewModel.fetchedImagesFromCD = await instagramViewModel.fetchImagesFromLibraty()
            }
        }
    }
}

struct TabBarButton: View {
    
    var image: String
    // Since we're having asset Image
    var isSystemImage: Bool
    var animation: Namespace.ID
    @Binding var selectedTab: String
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = image
            }
        } label: {
            VStack(spacing: 12) {
                (
                    isSystemImage ? Image(systemName: image) : Image(image)
                )
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(selectedTab == image ? .primary : .gray)
                
                ZStack {
                    if selectedTab == image {
                        Rectangle()
                            .fill(Color.primary)
                        // For smooth sliding effect...
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                    }
                }
                .frame(height: 1)
                
            }
            
        }

    }
}
