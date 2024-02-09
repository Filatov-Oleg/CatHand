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
                Image(systemName: "photo.on.rectangle.angled")
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
                FiltersScreen(filterImageViewModel: filterImageViewModel)
            }
        }
        .position(y:100)
        .padding([.horizontal, .vertical])
    }
}

#Preview {
    FiltersStartScreen()
}
