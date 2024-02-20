//
//  BlurList.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 29.09.2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct FiltersList: View {

    let id: FiltersType
    var filters: [FilterModel]
    var applyFilter: (CIFilter) -> ()
    
    var body: some View {
        filterView()
    }
    
    @ViewBuilder
    func filterView() -> some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filters) { filterModel in
                        PhotoFilterCell(model: filterModel, onApplyFilter: applyFilter)
                    }
                }
            }
        }
    }
}

extension FiltersList: Equatable {
    static func == (lhs: FiltersList, rhs: FiltersList) -> Bool {
        lhs.id == rhs.id
    }
}

//ForEach(0..<100) { i in
//    Text("Example \(i)")
//        .font(.title)
//        .frame(width: 200, height: 200)
////                            .background(colors[i % colors.count])
//        .id(i)
//        .onTapGesture {
//            scrollProxy.scrollTo(8, anchor: .top)
//        }
//}

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


