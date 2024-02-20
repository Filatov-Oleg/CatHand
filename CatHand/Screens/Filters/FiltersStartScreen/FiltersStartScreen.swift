//
//  FiltersStartScreen.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 14.12.2023.
//

import PhotosUI
import SwiftUI
import SpriteKit

struct FiltersStartScreen: View {
    
    @StateObject var filterImageViewModel: FilterImageViewModel = .init()
    
    @State var isShowFilterScreen: Bool = false
    @State var showingImagePicker: Bool = false
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack {
            Button {
                showingImagePicker.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 70))
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height * 0.5)
                    .background(Color.gray.opacity(0.5))
                    .padding(.horizontal)
                    .padding(.top, UIScreen.main.bounds.size.height * 0.15)
            }
            .onAppear {
                print("x: \(UIScreen.main.bounds.size.width), y: \(UIScreen.main.bounds.size.height)")
            }
            .onChange(of: filterImageViewModel.inputImage) { _ in
                isShowFilterScreen = true
                filterImageViewModel.loadImage()
            }
            .sheet(isPresented: $showingImagePicker) {
//                ImagePicker(selectedImage: $filterImageViewModel.inputImage)
                ImagePicker(image: $filterImageViewModel.inputImage)
            }
            .fullScreenCover(isPresented: $isShowFilterScreen) {
                FiltersScreen()
            }
        }
        .environmentObject(filterImageViewModel)
//        .padding([.horizontal, .vertical])
    }
}

#Preview {
    FiltersStartScreen()
}
