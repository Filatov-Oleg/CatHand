//
//  FilterImageViewModel.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 29.09.2023.
//

import Foundation
import SwiftUI


final public class FilterImageViewModel: ObservableObject {
    
    @Published var image: Image?
    @Published var imageGradient: Image?
    @Published var filterIntensity = 0.5
    @Published var showingImagePicker = false
    @Published var inputImage: UIImage?
//    @Published private var showingFilterSheet = false
    @Published var processedImage: UIImage?
    var changedImages: [ContentImage] = []
    @Published var currentFilter: CIFilter?
//    @Published private var showDetailFilters: Bool = false
    @Published var outputImage: CIImage?
    @Published var point1ToPoint2 = 5.0
    @Published var filtersType: FiltersType = .none
    
    private var preApplyImage: UIImage = UIImage()
    
    let context = CIContext()
    
//    init(selectedImage: UIImage?) {
//        self.inputImage = selectedImage
//    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func loadImage() {
        if showingImagePicker {
            guard let inputImage = inputImage else { return }
            processedImage = inputImage
            image = Image(uiImage: inputImage)
        } else {
            if let processedImage = processedImage {
                let CIProcessedImage = CIImage(image: processedImage)
                if let inputKeys = currentFilter?.inputKeys {
                    if inputKeys.contains(kCIInputImageKey) {
                        currentFilter?.setValue(CIProcessedImage, forKey: kCIInputImageKey)
                    }
                }
                applyProcessing(by: filterIntensity)
            } else {
                guard let inputImage = inputImage else { return }
                processedImage = inputImage
                image = Image(uiImage: inputImage)
    //            let beginImage = CIImage(image: inputImage)
    //            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    //            applyProcessing()
            }
        }
        

    }

    func applyProcessing(by filterIntensity: Double) {
        if let inputKeys = currentFilter?.inputKeys {
            if let guardCurrentFilter = self.currentFilter {
//                print("inputKeys ===> \(inputKeys)")
//                let input = CIImage(image: processedImage!)!
                
                switch filtersType {
                case .photoEffect:
                    print("photoEffect")
                case .blur:
                    applyBlur(filter: guardCurrentFilter)
                case .saturation:
                    applySaturation(filter: guardCurrentFilter)
                case .vignette:
                    applyVignette(filter: guardCurrentFilter)
                case .crystallize:
                    applyCrystallize(filter: guardCurrentFilter)
                case .pixellate:
                    applyPixellate(filter: guardCurrentFilter)
                case .linearToSRGBToneCurve:
                    print("linearToSRGBToneCurve")
                case .none:
                    break
                }
                
                guard let outputImage = guardCurrentFilter.outputImage else {
                    print("NOT WORK")
                    return
                }
                handeResultFilter(by: outputImage)
            }
        }
    }
    

    func handeResultFilter(by outputImage: CIImage) {
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg, scale: 1, orientation: inputImage?.imageOrientation ?? .up)
            preApplyImage = uiImage
            image = Image(uiImage: uiImage)
//            processedImage = uiImage
        } else {
//            if let cgimg = context.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: input.extent.width, height: input.extent.height)) {
//                let uiImage = UIImage(cgImage: cgimg, scale: 1, orientation: inputImage?.imageOrientation ?? .up)
//                imageGradient = Image(uiImage: uiImage)
////                        processedImage = uiImage
//            }
        }
    }
    
    func applyFilter() {
        if processedImage != nil {
            let contentImage = ContentImage(image: preApplyImage, filterIntensity: filterIntensity, imageFilter: currentFilter ?? CIFilter())
            changedImages.append(contentImage)
            self.processedImage = preApplyImage
            filterIntensity = 0.5
        }
    }
    
    func undoFilterApplication() {
        if let lastChangedImage = changedImages.last {
            processedImage = lastChangedImage.image
            image = Image(uiImage: lastChangedImage.image)
//            filterIntensity = lastChangedImage.filterIntensity
        } else {
            processedImage = inputImage
            image = Image(uiImage: inputImage ?? UIImage())
        }
    }
    
    func needShowSlider() -> Bool {
        if currentFilter == nil {
            return false
        } else {
            switch filtersType {
            case .photoEffect:
                return false
            case .blur:
                return true
            case .saturation:
                return true
            case .vignette:
                return true
            case .crystallize:
                return true
            case .pixellate:
                return true
            case .linearToSRGBToneCurve:
                return false
            case .none:
                return false
            }
        }
    }
}

extension FilterImageViewModel {

    func applyBlur(filter: CIFilter) {
        if filter.inputKeys.contains(kCIInputAmountKey) {
            filter.setValue(Float(filterIntensity) * 10, forKey: kCIInputAmountKey)
        }
        if filter.inputKeys.contains(kCIInputRadiusKey) {
            filter.setValue(filterIntensity * 100, forKey: kCIInputRadiusKey)
        }
    }
    
    func applySaturation(filter: CIFilter) {
        //                    if inputKeys.contains("inputSaturation") {
        filter.setValue(Float(filterIntensity * 2.0), forKey: "inputSaturation")
        //                    }
    }
    
    func applyVignette(filter: CIFilter) {
//        if inputKeys.contains(kCIInputIntensityKey) {
        filter.setValue(filterIntensity * 10, forKey: kCIInputIntensityKey)
//        }
//        if inputKeys.contains(kCIInputRadiusKey) {
        filter.setValue(filterIntensity * 100, forKey: kCIInputRadiusKey)
//        }
    }
    
    func applyCrystallize(filter: CIFilter) {
        filter.setValue(filterIntensity * 100, forKey: kCIInputRadiusKey)
    }
    
    func applyPixellate(filter: CIFilter) {
        filter.setValue(filterIntensity * 20, forKey: kCIInputScaleKey)
    }

    @MainActor
    func removeBackgroundImage() {
        guard let processedImage = processedImage else {
            return
        }
        Task {
            let uiImage = try? await removeBackground(of: processedImage)
            guard let cgImage = uiImage?.cgImage else { return }
            let helpUIImage = UIImage(cgImage: cgImage, scale: 1, orientation: inputImage?.imageOrientation ?? .up)
            self.processedImage = helpUIImage
            image = Image(uiImage: helpUIImage)
            
        }
    }
    
}

extension FilterImageViewModel {
    func save() {
        guard let processedImage = processedImage else { return }
        let imageSaver = ImageSaver()
        imageSaver.successHandler = {
            print("Success!")
        }
        imageSaver.errorHandler = {
            print("Oops: \($0.localizedDescription)")
        }
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func newImage() {
        inputImage = nil
        imageGradient = nil
        currentFilter = nil
        processedImage = nil
        changedImages = []
        imageGradient = nil
        filtersType = .none
        showingImagePicker = true
    }
    
    func close() {
        imageGradient = nil
        currentFilter = nil
        processedImage = nil
        changedImages = []
        imageGradient = nil
        filtersType = .none
    }
}

//if inputKeys.contains("inputMaxComponents") {
//    guardCurrentFilter.setValue(CIVector(x: filterIntensity, y: filterIntensity, z: filterIntensity, w: 1.0), forKey: "inputMaxComponents")
//}
//
//if inputKeys.contains("inputPoint0") {
//    print("width: \(input.extent.width), height: \(input.extent.height)")
//    guardCurrentFilter.setValue(CIVector(
//        x: input.extent.width,
//        y: input.extent.height / 2),
//                                forKey: "inputPoint0")
//}
//if inputKeys.contains("inputPoint1") {
//    guardCurrentFilter.setValue(CIVector(
//        x:  input.extent.width - point1ToPoint2 * 100,
//        y:  input.extent.height / 2),
//                                forKey: "inputPoint1")
//}
//
//if inputKeys.contains("inputColor0") {
//    guardCurrentFilter.setValue(CIColor(red: 246/255, green: 66/255, blue: 227/255, alpha: 0.1),
//                                forKey: "inputColor0")
//}
//
//if inputKeys.contains("inputColor1") {
//    guardCurrentFilter.setValue(CIColor(red: 246/255, green: 66/255, blue: 227/255, alpha: filterIntensity),
//                                forKey: "inputColor1")
//}
//
//if inputKeys.contains(kCIInputCenterKey) {
//    guardCurrentFilter.setValue(CIVector(
//        x: input.extent.width - input.extent.width / 2,
//        y: input.extent.height - input.extent.height / 2),
//                                forKey: kCIInputCenterKey)
//}
