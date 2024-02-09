//
//  PhotoFilterCell.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 26.09.2023.
//

import SwiftUI

struct PhotoFilterCell: View {
    
    @ObservedObject var filterImageViewModel: FilterImageViewModel
    
    @Binding var inputImage: UIImage?

    @State private var image: Image?
    @State var nameFilter: String?
    @State var isSelected: Bool = false
    
    @State var filterIntensity = 1.0
    @State var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var processedImage: UIImage?
    
    var onApplyFilter: () -> Void
    
    let context = CIContext()
    
    var body: some View {
        VStack {
            Button {
                isSelected.toggle()
                onApplyFilter()
            } label: {
                image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 68, height: 68)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.blackOrWhiteColor)
                    )
            }
            .onAppear {
                print("FILTER ===> \(currentFilter)")
                print("image ===> \(image)")
                    setFilter(currentFilter)
            }
            .onDisappear {
                print("onDisappear")
            }
            .onChange(of: inputImage, perform: { newValue in
                print("CHANGE ===> \(currentFilter)")
                setFilter(currentFilter)
            })
            Text(currentFilter.name)
                .foregroundStyle(Color.blackOrWhiteColor)
                .font(.caption2)
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputAmountKey) {
            currentFilter.setValue(Float(filterIntensity) * 10, forKey: kCIInputAmountKey)
        }
        
        if inputKeys.contains(kCIInputColorKey) {
            currentFilter.setValue(CIColor.green, forKey: kCIInputColorKey)
        }
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 100, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { 
            return
        }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg, scale: 1, orientation: inputImage?.imageOrientation ?? .up)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }

    func circleOverlay() -> some View {
        if isSelected {
            return AnyView(Circle()
                .stroke(Color.mainGradientBackground))
        } else {
           return AnyView(Circle()
                .stroke(Color.blackOrWhiteColor))
        }
    }
    
}
//struct PhotoFilterCell_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoFilterCell()
//    }
//}

