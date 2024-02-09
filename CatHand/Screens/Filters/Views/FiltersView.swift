//
//  FiltersView.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 11.12.2023.
//

import SwiftUI


struct FiltersView: View {
    
    @ObservedObject var filterImageViewModel: FilterImageViewModel

    @State private var showBlurList: Bool = false
    
//    @State private var type: FiltersType = .none
    
    var body: some View {
        HStack {
            Button {
                filterImageViewModel.currentFilter = nil
                filterImageViewModel.filtersType = .none
                filterImageViewModel.undoFilterApplication()
            } label: {
                Image("BackArrowIcon")
                    .padding()
            }
            .opacity(filterImageViewModel.filtersType != .none ? 1 : 0)
            .frame(width: filterImageViewModel.filtersType != .none ? 35 : 0)
            ZStack(alignment: .bottom) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        Button {
                            filterImageViewModel.filtersType = .photoEffect
                        } label: {
                            VStack {
                                Image("FiltersIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Фильтры")
                                    .font(.caption2)
                            }
                            .foregroundStyle(Color("TextColor"))
                        }
                        
                        Button {
                            filterImageViewModel.filtersType = .blur
                        } label: {
                            VStack {
                                Image("BlurIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Блюр")
                                    .font(.caption2)
                            }
                            .foregroundStyle(Color("TextColor"))
                        }
                        
                        Button {
                            filterImageViewModel.filtersType = .saturation
                            filterImageViewModel.setFilter(CIFilter.colorControls())
                        } label: {
                            VStack {
                                Image("BlurIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Контрастность")
                                    .font(.caption2)
                            }
                            .foregroundStyle(Color("TextColor"))
                        }
                        
                        Button {
                            filterImageViewModel.filtersType = .vignette
                            filterImageViewModel.setFilter(CIFilter.vignette())
                        } label: {
                            VStack {
                                Image("BlurIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Затемнение")
                                    .font(.caption2)
                            }
                            .foregroundStyle(Color("TextColor"))
                        }
                        
                        Button {
                            filterImageViewModel.filtersType = .crystallize
                            filterImageViewModel.setFilter(CIFilter.crystallize())
                        } label: {
                            VStack {
                                Image("BlurIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Кристализация")
                                    .font(.caption2)
                            }
                            .foregroundStyle(Color("TextColor"))
                        }
                        
                        Button {
                            filterImageViewModel.filtersType = .pixellate
                            filterImageViewModel.setFilter(CIFilter.pixellate())
                        } label: {
                            VStack {
                                Image("BlurIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Пикселизация")
                                    .font(.caption2)
                            }
                            .foregroundStyle(Color("TextColor"))
                        }

                        Button {
                            filterImageViewModel.filtersType = .linearToSRGBToneCurve
                            filterImageViewModel.setFilter(CIFilter.linearToSRGBToneCurve())
                        } label: {
                            VStack {
                                Image("FiltersIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("linearToSRGBToneCurve")
                                    .font(.caption2)
                            }
                            .foregroundStyle(Color("TextColor"))
                        }
                        
                        Button {
                            filterImageViewModel.filtersType = .linearToSRGBToneCurve
                            filterImageViewModel.setFilter(CIFilter.sRGBToneCurveToLinear())
                        } label: {
                            VStack {
                                Image("FiltersIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("sRGBToneCurveToLinear")
                                    .font(.caption2)
                            }
                            .foregroundStyle(Color("TextColor"))
                        }
                        
                        Button {
                            filterImageViewModel.removeBackgroundImage()
                        } label: {
                            VStack {
                                Image(systemName: "scissors")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Удалить фон")
                                    .font(.caption2)
                            }
                            .foregroundStyle(Color("TextColor"))
                        }
                    }
                }.opacity(filterImageViewModel.filtersType != .none ? 0 : 1)
    
                if filterImageViewModel.filtersType == .photoEffect  {
                    HStack {
                        PhotoEffectList(filterImageViewModel: filterImageViewModel)
                    }
                }
                
                if filterImageViewModel.filtersType == .blur {
                    HStack {
                        BlurList(filterImageViewModel: filterImageViewModel)
                    }
                }

            }
            .frame(height: 100)

            Button {
                filterImageViewModel.applyFilter()
                filterImageViewModel.filtersType = .none
                filterImageViewModel.currentFilter = nil
            } label: {
                Image("DoneIcon")
                    .padding()
            }
            .opacity(filterImageViewModel.filtersType != .none ? 1 : 0)
            .frame(width: filterImageViewModel.filtersType != .none ? 45 : 0)
        }
    }
}

//#Preview {
//    FiltersView(filterImageViewModel: .init())
//}


//                    Button("Обрезать") {showCropView.toggle()}
//                    Button(CIFilter.colorClamp().name) { filterImageViewModel.setFilter(CIFilter.colorClamp()) }
//
//                    Button("colorBurnBlendMode") { filterImageViewModel.setFilter(CIFilter.colorBurnBlendMode()) }
//                    Button("Crystallize") { filterImageViewModel.setFilter(CIFilter.crystallize()) }
//                    Button("CIColorMonochrome") { filterImageViewModel.setFilter(CIFilter.colorMonochrome())}
//                    Button("Pixellate") { filterImageViewModel.setFilter(CIFilter.pixellate()) }
//                            Button("Sepia Tone") { filterImageViewModel.setFilter(CIFilter.sepiaTone()) }
//                            Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }

