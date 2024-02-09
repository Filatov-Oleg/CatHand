//
//  ImageCarouselHelper.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 23.11.2023.
//

import SwiftUI

import SwiftUI


/// Retreiving embeded UIScrollView from the SwiftUI scrollView
struct ImageCarouselHelper: UIViewRepresentable {
    /// Retreive what ever properties you needed from the ScrollView with the helper of @Binding
    var pageWidth: CGFloat
    var pageCount: Int
    @Binding var index: Int
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.decelerationRate = .fast
                scrollView.delegate = context.coordinator
                context.coordinator.pageCount = pageCount
                context.coordinator.pageWidth = pageWidth
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ImageCarouselHelper
        var pageWidth: CGFloat = 0
        var pageCount: Int = 0
        init(parent: ImageCarouselHelper) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            /// Adding velocity toom for making perfect scroll animation
            let targetEnd = scrollView.contentOffset.x + (velocity.x * 60)
            let targetIndex = (targetEnd / pageWidth).rounded()
            
            /// Updating current index
            let index = min(max(Int(targetIndex), 0), pageCount - 1)
            parent.index = index
            
            targetContentOffset.pointee.x = targetIndex * pageWidth
        }
    }
}


