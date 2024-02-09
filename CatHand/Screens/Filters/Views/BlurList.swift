//
//  BlurList.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 29.09.2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct BlurList: View {

    @ObservedObject var filterImageViewModel: FilterImageViewModel
    
    let filters: [FilterModel] = [FilterModel(filter: CIFilter.boxBlur()),
                                  FilterModel(filter: CIFilter.discBlur()),
                                  FilterModel(filter: CIFilter.gaussianBlur())]
    
    var body: some View {
        filterView()
    }
    
    @ViewBuilder
    func filterView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(filters) { filter in
                    PhotoFilterCell(filterImageViewModel: filterImageViewModel, inputImage: $filterImageViewModel.processedImage, currentFilter: filter.filter) {
                        filterImageViewModel.setFilter(filter.filter)
                    }
                }
            }
        }
    }
}

//                PhotoFilterCell(inputImage: $filterImageViewModel.inputImage, currentFilter: CIFilter.median()) {
//                    filterImageViewModel.setFilter(CIFilter.median())
//                }
//                PhotoFilterCell(inputImage: $filterImageViewModel.inputImage, currentFilter: CIFilter.motionBlur()) {
//                    filterImageViewModel.setFilter(CIFilter.motionBlur())
//                }
//                PhotoFilterCell(inputImage: $filterImageViewModel.inputImage, currentFilter: CIFilter.noiseReduction()) {
//                    filterImageViewModel.setFilter(CIFilter.noiseReduction())
//                }
//                PhotoFilterCell(inputImage: $filterImageViewModel.inputImage, currentFilter: CIFilter.zoomBlur()) {
//                    filterImageViewModel.setFilter(CIFilter.zoomBlur())
//                }


