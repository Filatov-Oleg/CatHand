//
//  PhotoEffectList.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 29.09.2023.
//

import SwiftUI

struct PhotoEffectList: View {
    
    @ObservedObject var filterImageViewModel: FilterImageViewModel
    
    let filters: [FilterModel] = [FilterModel(filter: CIFilter.photoEffectChrome()),
                                  FilterModel(filter: CIFilter.photoEffectFade()),
                                  FilterModel(filter: CIFilter.photoEffectInstant()),
                                  FilterModel(filter: CIFilter.photoEffectNoir()),
                                  FilterModel(filter: CIFilter.photoEffectProcess()),
                                  FilterModel(filter: CIFilter.photoEffectTonal()),
                                  FilterModel(filter: CIFilter.photoEffectTransfer())]
    
    var body: some View {
        filterView()
    }
    
    @ViewBuilder
    func filterView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(filters) { filter in
                    PhotoFilterCell(filterImageViewModel: filterImageViewModel, inputImage: $filterImageViewModel.inputImage, currentFilter: filter.filter) {
                        filterImageViewModel.setFilter(filter.filter)
                    }
                }
            }
        }
    }
}

//struct PhotoEffectList_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoEffectList(filterImageViewModel: FilterImageViewModel())
//    }
//}


