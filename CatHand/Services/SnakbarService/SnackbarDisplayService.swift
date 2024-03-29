//
//  SnackbarDisplayService.swift
//  CatHand
//
//  Created by Филатов Олег Олегович on 17.02.2024.
//

import SwiftUI

struct Snack<T: View>: ViewModifier {
    let view: T
    let alignment: Alignment
    let direction: Direction
    let isPresented: Bool

    init(isPresented: Bool, alignment: Alignment, direction: Direction, @ViewBuilder content: () -> T) {
        self.isPresented = isPresented
        self.alignment = alignment
        self.direction = direction
        view = content()
    }

    func body(content: Content) -> some View {
        content
            .overlay(popupContent())
    }

    @ViewBuilder
    private func popupContent() -> some View {
        GeometryReader { geometry in
            if isPresented {
                view
                    .animation(.spring())
                    .transition(.offset(x: 0, y: direction.offset(popupFrame: geometry.frame(in: .global))))
                    .frame(width: geometry.size.width , height: geometry.size.height, alignment: alignment)
            }
        }
    }
}

extension Snack {
    enum Direction {
        case top, bottom

        func offset(popupFrame: CGRect) -> CGFloat {
            switch self {
            case .top:
                let aboveScreenEdge = -popupFrame.maxY
                return aboveScreenEdge
            case .bottom:
                let belowScreenEdge = UIScreen.main.bounds.height - popupFrame.minY
                return belowScreenEdge
            }
        }
    }
}

extension View {
    func showSnack<T: View>(
        isPresented: Bool,
        alignment: Alignment = .center,
        direction: Snack<T>.Direction = .bottom,
        @ViewBuilder content: () -> T
    ) -> some View {
        return modifier(Snack(isPresented: isPresented, alignment: alignment, direction: direction, content: content))
    }
}

//private extension View {
//    func onGlobalFrameChange(_ onChange: @escaping (CGRect) -> Void) -> some View {
//        background(GeometryReader { geometry in
//            Color.clear.preference(key: FramePreferenceKey.self, value: geometry.frame(in: .global))
//        })
//        .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
//    }
//
//    func print(_ varargs: Any...) -> Self {
//        Swift.print(varargs)
//        return self
//    }
//}
//
//private struct FramePreferenceKey: PreferenceKey {
//    static let defaultValue = CGRect.zero
//    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
//        value = nextValue()
//    }
//}
//
//private extension View {
//    @ViewBuilder func applyIf<T: View>(_ condition: @autoclosure () -> Bool, apply: (Self) -> T) -> some View {
//        if condition() {
//            apply(self)
//        } else {
//            self
//        }
//    }
//}
