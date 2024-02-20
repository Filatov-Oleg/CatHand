//
//  FilterModel.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 06.02.2024.
//

import Foundation
import CoreImage
import UIKit

struct FilterModel: Identifiable, Hashable {
    let id: UUID = .init()
    let name: String
    let filter: CIFilter
    var image: UIImage
    let filterIntensity = 1
    var isSelected: Bool = false
    let context = CIContext()
    
    init(name: String = "Filter", filter: CIFilter, image: UIImage) {
        self.name = name
        self.filter = filter
        self.image = image
        applyFilter()
    }
    
    mutating func applyFilter() {
        let beginImage = CIImage(image: self.image)
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        
        if filter.inputKeys.contains(kCIInputAmountKey) {
            filter.setValue(Float(filterIntensity) * 10, forKey: kCIInputAmountKey)
        }
        if filter.inputKeys.contains(kCIInputRadiusKey) {
            filter.setValue(filterIntensity * 100, forKey: kCIInputRadiusKey)
        }
        
        guard let outputImage = filter.outputImage else {
            print("NOT WORK MODEL")
            return
        }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg, scale: 1, orientation: image.imageOrientation)
            self.image = uiImage
        }
    }
    
    mutating func selectFilter() {
        self.isSelected = true
    }
}
