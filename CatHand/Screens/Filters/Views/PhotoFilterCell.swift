//
//  PhotoFilterCell.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 26.09.2023.
//

import SwiftUI

struct PhotoFilterCell: View {
    
    var model: FilterModel
    
//    @State var isSelected: Bool = false
    
    var onApplyFilter: (CIFilter) -> Void
    
//    init(onApplyFilter: @escaping (CIFilter) -> Void) {
//        self.onApplyFilter = onApplyFilter
//    }
    
    var body: some View {
        VStack {
            Button {
                onApplyFilter(model.filter)
            } label: {
                Image(uiImage: model.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(model.isSelected ? Color(uiColor: UIColor(hexString: "#E674A5")) : Color.blackOrWhiteColor, lineWidth: 1.5)
                    )
            }
            Text(model.name)
                .foregroundStyle(Color.blackOrWhiteColor)
                .font(.caption2)
        }
        .padding(.top)
        .onAppear {
//            if model.isSelected {
//                onApplyFilter(model.filter)
//            }
        }
    }
}

extension PhotoFilterCell: Equatable {
    static func == (lhs: PhotoFilterCell, rhs: PhotoFilterCell) -> Bool {
        lhs.model.id == rhs.model.id
    }
}
