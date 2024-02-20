//
//  FiltersView.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 11.12.2023.
//

import SwiftUI


struct FiltersView: View {

    @EnvironmentObject var filterImageViewModel: FilterImageViewModel

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
                            filterImageViewModel.filtersType = .saturation
                            filterImageViewModel.setFilter(CIFilter.colorControls())
                        } label: {
                            VStack {
                                Image("SaturationIcon")
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
                                Image("VignetteIcon")
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
                                Image("CrystallizeIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Кристализация")
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
                            filterImageViewModel.filtersType = .pixellate
                            filterImageViewModel.setFilter(CIFilter.pixellate())
                        } label: {
                            VStack {
                                Image("PixellateIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Пикселизация")
                                    .font(.caption2)
                            }
                            .foregroundStyle(Color("TextColor"))
                        }
                        
                        Button {
                            filterImageViewModel.removeBackgroundImage()
                        } label: {
                            VStack {
                                Image("DeleteBackgroundIcon")
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
                    FiltersList(id: .photoEffect, filters: filterImageViewModel.photoEffectFilters(), applyFilter: filterImageViewModel.setFilter(_:))
                }
                
                if filterImageViewModel.filtersType == .blur {
                    FiltersList(id: .blur, filters: filterImageViewModel.blurFilters(), applyFilter: filterImageViewModel.setFilter(_:))
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

