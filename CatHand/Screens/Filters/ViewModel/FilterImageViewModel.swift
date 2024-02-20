//
//  FilterImageViewModel.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 29.09.2023.
//

import Foundation
import SwiftUI

enum FilterScreenState {
    case loading
    case content
}

final public class FilterImageViewModel: ObservableObject {
    
    @Published var image: Image?
    @Published var filterIntensity = 0.5
    @Published var showingImagePicker = false
    @Published var inputImage: UIImage?
    @Published var processedImage: UIImage?
    @Published var currentFilter: CIFilter?
    @Published var outputImage: CIImage?
    @Published var filtersType: FiltersType = .none
    @Published var currentState: FilterScreenState = .content

    @Published var showSaveSuccessSnack: Bool = false

    var changedImages: [ContentImage] = []
    private var preApplyImage: UIImage = UIImage()
    
    let context = CIContext()
    
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
                switch filtersType {
                case .photoEffect:
                    break
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
                    break
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
            case .blur, .saturation, .vignette, .crystallize, .pixellate:
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
//        if filter.inputKeys.contains(kCIInputAmountKey) {
//            filter.setValue(Float(filterIntensity) * 10, forKey: kCIInputAmountKey)
//        }
//        if filter.inputKeys.contains(kCIInputRadiusKey) {
            filter.setValue(filterIntensity * 100, forKey: kCIInputRadiusKey)
//        }
    }
    
    func applySaturation(filter: CIFilter) {
        //                    if inputKeys.contains("inputSaturation") {
        filter.setValue(Float(filterIntensity * 2.0), forKey: "inputSaturation")
        //                    }
    }
    
    func applyVignette(filter: CIFilter) {
//        if inputKeys.contains(kCIInputIntensityKey) {
        filter.setValue(filterIntensity * 5, forKey: kCIInputIntensityKey)
//        }
//        if inputKeys.contains(kCIInputRadiusKey) {
        filter.setValue(filterIntensity * 50, forKey: kCIInputRadiusKey)
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
        currentState = .loading
        guard let processedImage = processedImage else {
            return
        }

        Task {
            do {
                let uiImage = try await removeBackground(of: processedImage)
                guard let cgImage = uiImage.cgImage else { return }
                let helpUIImage = UIImage(cgImage: cgImage, scale: 1, orientation: inputImage?.imageOrientation ?? .up)
                self.processedImage = helpUIImage
                image = Image(uiImage: helpUIImage)
                self.currentState = .content
            } catch {
                print("ERROR: \(error.localizedDescription)")
                self.currentState = .content
            }
        }
    }
    
}

extension FilterImageViewModel {
    func save() {
        guard let processedImage = processedImage else { return }
        let imageSaver = ImageSaver()
        imageSaver.successHandler = {
            self.showSaveSuccessSnack.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showSaveSuccessSnack.toggle()
            }
        }
        imageSaver.errorHandler = {
            print("ERROR: \($0.localizedDescription)")
        }
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func newImage() {
//        inputImage = nil
        currentFilter = nil
//        processedImage = nil
        changedImages = []
        filtersType = .none
        showingImagePicker = true
    }
    
    func close() {
        currentFilter = nil
        processedImage = nil
        changedImages = []
        filtersType = .none
    }
    
    func applyPreviousFilter() {
        changedImages.removeLast()
        if let contentImage = changedImages.last {
            processedImage = contentImage.image
            filterIntensity = contentImage.filterIntensity
            currentFilter = contentImage.imageFilter
            image = Image(uiImage: contentImage.image)
        } else {
            processedImage = inputImage
            currentFilter = nil
            image = Image(uiImage: inputImage!)
            
        }
    }

    func longProccess() {
        currentState = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            self.currentState = .content
        }
    }
}

extension FilterImageViewModel {
    
    func blurFilters() -> [FilterModel] {
//        blurFilters.indices.forEach { blurFilters[$0].image = self.inputImage! }
//        blurFilters[index].isSelected = true

//        guard let index = blurFiltersList.firstIndex(where: {$0.filter == currentFilter}) else {
//            print("FALSE = \(blurFiltersList.count)")
//            return blurFiltersList
//        }
//        print("TRUE")
//        blurFiltersList.indices.forEach { blurFiltersList[$0].isSelected = false }
//        blurFiltersList[index].selectFilter()
        let blurFiltersList: [FilterModel] = [FilterModel(name: "Блюр 1", filter: CIFilter.boxBlur(), image: self.inputImage ?? UIImage()),
                                          FilterModel(name: "Блюр 2", filter: CIFilter.discBlur(), image:  self.inputImage ?? UIImage()),
                                          FilterModel(name: "Блюр 3", filter: CIFilter.gaussianBlur(), image: self.inputImage ?? UIImage())]
        return blurFiltersList
    }
    
    func photoEffectFilters() -> [FilterModel] {
        let photoEffectfilters: [FilterModel] = [FilterModel(name: "Chrome", filter: CIFilter.photoEffectChrome(), image: self.inputImage ?? UIImage()),
                                      FilterModel(name: "Fade", filter: CIFilter.photoEffectFade(), image: self.inputImage ?? UIImage()),
                                      FilterModel(name: "Instant", filter: CIFilter.photoEffectInstant(), image: self.inputImage ?? UIImage()),
                                      FilterModel(name: "Noir", filter: CIFilter.photoEffectNoir(), image: self.inputImage ?? UIImage()),
                                      FilterModel(name: "Process", filter: CIFilter.photoEffectProcess(), image: self.inputImage ?? UIImage()),
                                      FilterModel(name: "Tonal", filter: CIFilter.photoEffectTonal(), image: self.inputImage ?? UIImage()),
                                      FilterModel(name: "Transfer", filter: CIFilter.photoEffectTransfer(), image: self.inputImage ?? UIImage())]
        
//        photoEffectfilters.indices.filter { photoEffectfilters[$0].filter == currentFilter }
//                          .forEach { photoEffectfilters[$0].selectFilter() }
//        photoEffectfilters.indices.forEach { photoEffectfilters[$0].selectFilter()}
        return photoEffectfilters
    }
}
