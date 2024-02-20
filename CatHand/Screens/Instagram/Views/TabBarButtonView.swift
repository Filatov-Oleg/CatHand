//
//  TabBarButtonView.swift
//  CatHand
//
//  Created by Филатов Олег Олегович on 19.02.2024.
//

import SwiftUI

enum TabBarType: String {
    case photo = "square.grid.3x3"
    case video = "play.square"
}

struct TabBarButton: View {
    
    var image: TabBarType
    // Since we're having asset Image
    var isSystemImage: Bool
    var animation: Namespace.ID
    @Binding var selectedTab: TabBarType
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = image
            }
        } label: {
            VStack(spacing: 12) {
                (
                    isSystemImage ? Image(systemName: image.rawValue) : Image(image.rawValue)
                )
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(selectedTab == image ? .primary : .gray)
                
                ZStack {
                    if selectedTab == image {
                        Rectangle()
                            .fill(Color.primary)
                        // For smooth sliding effect...
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                    }
                }
                .frame(height: 1)
                
            }
            
        }

    }
}
