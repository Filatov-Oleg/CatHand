//
//  FiltersScreen.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 20.09.2023.
//

import SwiftUI



struct FiltersScreen: View {
    
    @EnvironmentObject var filterImageViewModel: FilterImageViewModel
    @Environment(\.dismiss) var dismiss

    @State private var showingFilterSheet = false
    @State private var showCropView: Bool = false
    @State private var showCloseAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                topBarView()
                photoImageView()
                auxiliaryTools()
                FiltersView()
            }
            .background(Color.backgroundColor) 
            .disabled(filterImageViewModel.currentState == .loading ? true : false)
            .onChange(of: filterImageViewModel.inputImage) { _ in
                filterImageViewModel.loadImage()
            }
            .showSnack(isPresented: filterImageViewModel.showSaveSuccessSnack, alignment: .top,
                   direction: .top, content: {
                SnackbarView(snackTitle: "Изображение сохранено")
            })
            .sheet(isPresented: $filterImageViewModel.showingImagePicker) {
                ImagePicker(image: $filterImageViewModel.inputImage)
            }
            .alert("Вы уверены, что хотите выйти?", isPresented: $showCloseAlert, actions: {
                Button("Выйти", action: {
                    dismiss()
                    filterImageViewModel.close()
                })
                Button("Отменить", role: .cancel, action: {
                    
                })
            }, message: {
                Text("Изменения будут отменены")
            })
//            .fullScreenCover(isPresented: $showCropView) {
//                /// When exited clearing the old selected image
//                //                selectedImage = nil
//            } content: {
//                CropperView(inputImage: filterImageViewModel.processedImage!, croppedImage: $filterImageViewModel.processedImage) {
//                    guard let cgImage = filterImageViewModel.processedImage?.cgImage else { return }
//                    let helpUIImage = UIImage(cgImage: cgImage, scale: 1, orientation: filterImageViewModel.inputImage?.imageOrientation ?? .up)
//                    filterImageViewModel.image = Image(uiImage: helpUIImage)
//                }
//            }
        }
        .navigationViewStyle(.stack)
    }
    
    
    @ViewBuilder
    func topBarView() -> some View {
        HStack {
            Button {
                showCloseAlert.toggle()
            } label: {
                Image("HomeIcon")
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
    }
    
    @ViewBuilder
    func photoImageView() -> some View {
        ZStack {
            ZoomableScrollView {
                filterImageViewModel.image?
                    .resizable()
                    .scaledToFit()
            }
            .opacity(filterImageViewModel.image == nil ? 0 : 1)
            
            if filterImageViewModel.currentState == .loading {
                LoaderView()
            }
        }
    }
    
    @ViewBuilder
    func auxiliaryTools() -> some View {
        VStack(spacing: -5) {
            HStack {
                Button {
                    filterImageViewModel.applyPreviousFilter()
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
            sliderView()
        }
    }
    
    @ViewBuilder
    func sliderView() -> some View  {
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
//                                filterImageViewModel.longProccess()
                }
            }
            .opacity(filterImageViewModel.needShowSlider() ? 1 : 0)
        }
        .padding([.vertical, .horizontal])
    }
}

//Button("bokehBlur") { setFilter(CIFilter.bokehBlur()) }
//Button("boxBlur") { setFilter(CIFilter.boxBlur()) }
//Button("discBlur") { setFilter(CIFilter.discBlur()) }
//Button("gaussianBlur") { setFilter(CIFilter.gaussianBlur()) }
//Button("maskedVariableBlur") { setFilter(CIFilter.maskedVariableBlur()) }
//Button("median") { setFilter(CIFilter.median()) }
//Button("motionBlur") { setFilter(CIFilter.motionBlur()) }
//Button("noiseReduction") { setFilter(CIFilter.noiseReduction()) }
//Button("zoomBlur") { setFilter(CIFilter.zoomBlur()) }




