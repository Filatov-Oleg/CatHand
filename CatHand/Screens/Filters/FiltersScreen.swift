//
//  FiltersScreen.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 20.09.2023.
//

import SwiftUI



struct FiltersScreen: View {
    
    @ObservedObject var filterImageViewModel: FilterImageViewModel

//    @StateObject private var filterImageViewModel: FilterImageViewModel = .init()
    
    
//    init(selectedImage: UIImage?) {
//        self.selectedImage = selectedImage
//        _filterImageViewModel = StateObject(wrappedValue: FilterImageViewModel(selectedImage: selectedImage))
//    }
    
    @Environment(\.dismiss) var dismiss

    @State private var showingFilterSheet = false
    
    @State private var showCropView: Bool = false
    
    @State var lastScaleValue: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        dismiss()
                        filterImageViewModel.close()
                    } label: {
                        Image(systemName: "house")
                    }
                    Spacer()
                    HStack(spacing: 10) {
                        Button {
                            filterImageViewModel.newImage()
                        } label: {
                            Image("NewIcon")
                        }
        
                        Button {
                            filterImageViewModel.save()
                        } label: {
                            Image("DownloadIcon")
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                ZStack {
                    ZoomableScrollView {
                        filterImageViewModel.image?
                            .resizable()
                            .scaledToFit()
//                            .border(Color.white, width: 1)
                    }.opacity(filterImageViewModel.image == nil ? 0 : 1)
//                        .border(Color.red, width: 1)

                }

                VStack(spacing: -7) {
                    HStack {
                        Button {
                            filterImageViewModel.changedImages.removeLast()
                            if let contentImage = filterImageViewModel.changedImages.last {
                                filterImageViewModel.processedImage = contentImage.image
                                filterImageViewModel.filterIntensity = contentImage.filterIntensity
                                filterImageViewModel.currentFilter = contentImage.imageFilter
                                filterImageViewModel.image = Image(uiImage: contentImage.image)
                            } else {
                                filterImageViewModel.processedImage = filterImageViewModel.inputImage
                                filterImageViewModel.currentFilter = nil
                                filterImageViewModel.image = Image(uiImage: filterImageViewModel.inputImage!)
                                
                            }
                        } label: {
                            Image("BackIcon")
                        }.disabled(filterImageViewModel.changedImages.count == 0)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image("OriginalIcon")
                        }
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged({ _ in
                                    filterImageViewModel.image = Image(uiImage: filterImageViewModel.inputImage!)
                                })
                                .onEnded({ _ in
                                    filterImageViewModel.image = Image(uiImage: filterImageViewModel.processedImage!)
                                })
                        )
                    }
                    .padding(.horizontal)
                    HStack(alignment: .bottom) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 1)
                                .frame(height: 5)
                                .foregroundStyle(Color.mainGradientBackground)
                            UISliderView(value: $filterImageViewModel.filterIntensity,
                                         minValue: 0.01,
                                         maxValue: 1,
                                         thumbColor: .clear,
                                         minTrackColor: .clear,
                                         maxTrackColor: .clear)
                            .onChange(of: filterImageViewModel.filterIntensity) { newValue in
                                filterImageViewModel.applyProcessing(by: newValue)
                            }
                        }
                        .opacity(filterImageViewModel.needShowSlider() ? 1 : 0)
                    }
                    .padding([.vertical, .horizontal])
                }
                FiltersView(filterImageViewModel: filterImageViewModel)
            }
            .background(Color.backgroundColor) 
            //            .padding([.horizontal])
            .onChange(of: filterImageViewModel.inputImage) { _ in
                filterImageViewModel.loadImage()
            }
            .sheet(isPresented: $filterImageViewModel.showingImagePicker) {
//                ImagePicker(selectedImage: $filterImageViewModel.inputImage)
                ImagePicker(image: $filterImageViewModel.inputImage)
            }
            .sheet(isPresented: $showingFilterSheet) {
                FilterListView()
            }
//            .fullScreenCover(isPresented: $showCropView) {
//                /// When exited clearing the old selected image
//                //                selectedImage = nil
//            } content: {
//                CropperView(inputImage: filterImageViewModel.processedImage!, croppedImage: $filterImageViewModel.processedImage, cropBorderColor: .white, cropVerticesColor: .blue, cropperOutsideOpacity: 0.4) {
//                    filterImageViewModel.image = Image(uiImage: filterImageViewModel.processedImage!)
//                }
//                //                CropView(crop: .square, image: filterImageViewModel.processedImage) { croppedImage, status in
//                //                    if let croppedImage {
//                //                        filterImageViewModel.processedImage = croppedImage
//                //                        filterImageViewModel.image = Image(uiImage: croppedImage)
//                //                    }
//                //                }
//            }
            //            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
            //                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
            //            }
        }
        .navigationViewStyle(.stack)
    }
    
    
    
}

//struct FiltersScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        FiltersScreen()
//    }
//}

//Button("bokehBlur") { setFilter(CIFilter.bokehBlur()) }
//Button("boxBlur") { setFilter(CIFilter.boxBlur()) }
//Button("discBlur") { setFilter(CIFilter.discBlur()) }
//Button("gaussianBlur") { setFilter(CIFilter.gaussianBlur()) }
//Button("maskedVariableBlur") { setFilter(CIFilter.maskedVariableBlur()) }
//Button("median") { setFilter(CIFilter.median()) }
//Button("motionBlur") { setFilter(CIFilter.motionBlur()) }
//Button("noiseReduction") { setFilter(CIFilter.noiseReduction()) }
//Button("zoomBlur") { setFilter(CIFilter.zoomBlur()) }

struct FilterListView: View {
    let filterList = CIFilter.filterNames(inCategory: nil)
    
    var body: some View {
        NavigationView {
            List(filterList, id: \.self) { filter in
                NavigationLink(destination: FilterDetailView(filter: filter)) {
                    Text(filter)
                }
            }
            .navigationTitle("Filter List")
        }
    }
}

struct FilterList_Previews: PreviewProvider {
    static var previews: some View {
        FilterListView()
    }
}

struct FilterDetailView: View {
    var filter: String
    
    var body: some View {
        if let ciFilter = CIFilter(name: filter) {
            ScrollView {
                Text(ciFilter.attributes.description)
            }
        } else {
            Text("Unknown filter!")
        }
    }
}



