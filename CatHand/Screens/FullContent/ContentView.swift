//
//  ContentView.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 12.09.2023.
//

import PhotosUI
import SwiftUI

struct ContentImage: Identifiable {
    let id: UUID = .init()
    let image: UIImage
    let filterIntensity: Double
    let imageFilter: CIFilter
}

public class processedImageViewModel {
    
}

struct ContentView: View {

    @StateObject private var coreDataController = CoreDataController()
    
    @State var index = 0
    @State private var showBackView: Bool = true
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Button {
                        self.index = 0
                        withAnimation {
                            self.showBackView.toggle()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image("Ps")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Редактор")
                                .foregroundColor(.black)
                        }.padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(self.index == 0 ? .gray.opacity(0.4) : .clear)
                            .cornerRadius(10)
                    }
                    Button {
                        self.index = 1
                        withAnimation {
                            self.showBackView.toggle()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image("Instagram")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Инстаграмм")
                                .foregroundColor(.black)
                        }.padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(self.index == 1 ? .gray.opacity(0.4) : .clear)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        self.index = 2
                        withAnimation {
                            self.showBackView.toggle()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image("Planner")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Планер")
                                .foregroundColor(.black)
                        }.padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(self.index == 2 ? .gray.opacity(0.4) : .clear)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.top, 25)
                .padding(.horizontal, 20)
                Spacer(minLength: 0)
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            .offset(x: !self.showBackView ? -UIScreen.main.bounds.width / 1.5 : 0, y: !self.showBackView ? 15 : 0)
            .rotation3DEffect(.init(degrees: !self.showBackView ? -20 : 0), axis: (x: 0, y: 1, z: 0))
            
            VStack(spacing: 0) {
                HStack(spacing: 15) {
                    Button {
                        withAnimation {
                            self.showBackView.toggle()
                        }
                    } label: {
                        Image("lineHorizontal3")
                    }
                    Text(self.index == 0 ? "Редактор" : (self.index == 1 ? "Инстаграм" : (self.index == 2 ? "Планер" : "Мои заказы")))
                        .font(.title)
//                        .foregroundColor(.gray)
                        
                    Spacer(minLength: 0)
                }
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.leading)
                GeometryReader { _ in
                    VStack {
                        if self.index == 0 {
                            FiltersStartScreen()
                                .disabled(showBackView ? true : false)
                        } else if self.index == 1 {
                            InstagramScreen(instagramViewModel: InstagramViewModel(mocContext: coreDataController.container.viewContext))
                                .disabled(showBackView ? true : false)
                        } else if self.index == 2 {
                            PlannerScreen(viewModel: PlannerViewModel(mocContext:  coreDataController.container.viewContext))
                                .disabled(showBackView ? true : false)
                        } else {
                            EmptyView()
                        }
                    }
                }
                
            }
            .background(Color.backgroundColor)
            .cornerRadius(self.showBackView ? 30 : 0)
            .scaleEffect(self.showBackView ? 0.85 : 1)
            .offset(x: self.showBackView ? UIScreen.main.bounds.width / 1.5 : 0, y: self.showBackView ? 15 : 0)
            .rotation3DEffect(.init(degrees: self.showBackView ? -20 : 0), axis: (x: 0, y: 1, z: 0))
        }
        .background(Color.mainGradientBackground)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            requestPhotoLibraryAccess()
        }
        .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width < 0 {
                    if showBackView {
                        withAnimation {
                            self.showBackView.toggle()
                        }
                    }
                }
            }))
    }
    
    private func requestPhotoLibraryAccess() {
      let status = PHPhotoLibrary.authorizationStatus()

      switch status {
      case .notDetermined:
        PHPhotoLibrary.requestAuthorization { newStatus in
          if newStatus == .authorized {
            print("Access granted.")
          } else {
            print("Access denied.")
          }
        }
      case .restricted, .denied:
        print("Access denied or restricted.")
      case .authorized:
        print("Access already granted.")
      case .limited:
        print("Access limited.")
      @unknown default:
        print("Unknown authorization status.")
      }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//    //    func loadImage(with identity: Float = 0) {
//    func loadImage() {
//        guard let inputImage =  UIImage(named: "catAnn") else { return }
//        let beginImage = CIImage(image: inputImage)
//
//        let context = CIContext()
//
//        /// Сепия
//        let currentFilter = CIFilter.sepiaTone()
//        currentFilter.inputImage = beginImage
//        currentFilter.intensity = 1
//
//        /// Пиксели
//        //        let currentFilter = CIFilter.pixellate()
//        //        currentFilter.inputImage = beginImage
//        //        currentFilter.scale = 100
//
//        /// Кристаллы
//        //        let currentFilter = CIFilter.crystallize()
//        //        currentFilter.inputImage = beginImage
//        //        currentFilter.radius = 100
//
//        /// Вихрь
//        //        let currentFilter = CIFilter.twirlDistortion()
//        //        currentFilter.inputImage = beginImage
//        //        currentFilter.radius = 1000
//        //        currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
//
//
//
//        /// Старый метод вихрь
//        //        let currentFilter = CIFilter.twirlDistortion()
//        //        currentFilter.inputImage = beginImage
//        //
//        //        let amount = 1.0
//        //
//        //        let inputKeys = currentFilter.inputKeys
//        //
//        //        if inputKeys.contains(kCIInputIntensityKey) {
//        //            currentFilter.setValue(amount, forKey: kCIInputIntensityKey) }
//        //        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(amount * 130, forKey: kCIInputRadiusKey) }
//        //        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(amount * 15, forKey: kCIInputScaleKey) }
//
//        // get a CIImage from our filter or exit if that fails
//        guard let outputImage = currentFilter.outputImage else { return }
//
//        // attempt to get a CGImage from our CIImage
//        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
//            // convert that to a UIImage
//            let uiImage = UIImage(cgImage: cgimg)
//
//            // and convert that to a SwiftUI image
//            image = Image(uiImage: uiImage)
//        }
//    }


//        VStack {
//            image?
//                .resizable()
//                .scaledToFit()
////                .frame(maxHeight: 400)
//
//            Button("Select Image") {
//               showingImagePicker = true
//            }
//
//            Slider(value: $identity, in: 0...1, step: 0.001)
//                .padding(.horizontal, 30)
//                .onChange(of: identity) { newValue in
//                    print("New value is \(identity)")
//                    createFilterSepia(identity: identity)
//                }
//
//            Button("Save Image") {
//                guard let inputImage = inputImage else { return }
//
//                let imageSaver = ImageSaver()
//                imageSaver.writeToPhotoAlbum(image: inputImage)
//            }
//        }
//        .sheet(isPresented: $showingImagePicker) {
//            ImagePicker(image: $inputImage)
//        }
//        .onChange(of: inputImage) { _ in
//            loadImage1()
//        }

//        VStack(spacing: 40) {
//            image?
//                .resizable()
//                .scaledToFit()
//
//            Slider(value: $identity, in: 0...1, step: 0.01)
//                .padding(.horizontal, 30)
//                .onChange(of: identity) { newValue in
//                    print("New value is \(identity)")
//                }
//
//
//        }
//        .onAppear(perform: loadImage)

