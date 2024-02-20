//
//  LoaderView.swift
//  CatHand
//
//  Created by Филатов Олег Олегович on 15.02.2024.
//

import SwiftUI

struct LoaderView: View {
    @State private var offset: CGFloat = -130
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
//            Color.black.ignoresSafeArea(edges: .all)
            Color.clear.ignoresSafeArea(edges: .all)
//            Rectangle()
//                .fill(Material.ultraThin)
//                .ignoresSafeArea()
            ZStack {
                ForEach(0..<20) { i in
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.mainGradientBackground)
                        .offset(y: offset)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.5 * Double(i)), value: offset)
                        .rotationEffect(.degrees((360/20) * Double(i)))
                }
                
                ForEach(0..<20) { i in
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundStyle(Color.mainGradientBackground)
                        .offset(y: offset + 60)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.5 * Double(i)), value: offset)
                        .rotationEffect(.degrees((360/20) * Double(i)))
                }
            }
            .scaleEffect(0.5)
            .rotationEffect(.degrees(rotation))
            .animation(.linear(duration: 5).repeatForever(autoreverses: false), value: rotation)
        }
        .onAppear {
            offset += 30
            rotation = 360
        }
    }
}

#Preview {
    LoaderView()
}
