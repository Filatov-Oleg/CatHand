//
//  StoriesView.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 02.12.2023.
//

import SwiftUI
import CoreHaptics


struct StoriesView: View {
    
    @ObservedObject var viewModel: InstagramViewModel
    
//    @Binding var storyImages: [ImageAsset]
//    @Binding var deleteStoryIndex: Int
//    @Binding var carouselType: СarouselImagesType
    @Binding var isShowCarouselImages: Bool
    @State var isShowAlert: Bool = false
    @State var titleText: String = ""
//    @Binding var savedImagesIndex: Int

    @State private var isShowСonfirmationDialog: Bool = false
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(viewModel.storyImages) { image in
                    Button {

                    } label: {
                        VStack {
                            if let thumbnail = image.thumbnail {
                                Image(uiImage: thumbnail)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 65, height: 65)
                                    .clipShape(Circle())
                                    .padding(3)
                                    .overlay {
                                        Circle().stroke(Color.gray, lineWidth: 1)
                                    }
                            } else {
                                Circle()
                                    .fill(Color.mainGradientBackground)
                                    .frame(width: 65, height: 65)
                            }
                            Text(image.title)
                                .foregroundStyle(Color("TextColor"))
                                .font(.caption)
                        }
                        .frame(maxWidth: 75)
                    }
                    .onAppear {
                        prepareHaptics()
                    }
                    .simultaneousGesture(LongPressGesture().onEnded { _ in
                        isShowСonfirmationDialog.toggle()
                        complexSuccess()
                        viewModel.savedImagesIndex = viewModel.storyImages.firstIndex(of: image) ?? -1
                    })
                    .highPriorityGesture(TapGesture().onEnded {
                        viewModel.carouselType = .story
                        withAnimation {
                            isShowCarouselImages.toggle()
                        }
                        viewModel.savedImagesIndex = viewModel.storyImages.firstIndex(of: image) ?? -1
                        print("Story index = \(viewModel.savedImagesIndex)")
                        viewModel.deleteImageIndex = viewModel.savedImagesIndex
                    })
                    .confirmationDialog(
                        "",
                         isPresented: $isShowСonfirmationDialog
                    ) {
                        Button("Изменить подпись") {
                            isShowAlert.toggle()
                        }
                    }
                    .alert("Добавь название к своей истории", isPresented: $isShowAlert, actions: {
                        TextField("Текст", text: $titleText)
                        Button("Изменить", action: {
                            viewModel.changeStory(titleText)
                            titleText = ""
                        })
                        Button("Отменить", role: .cancel, action: {
                            
                        })
                    }, message: {

                    })
                }

                Button {
                    withAnimation {
                        viewModel.addNewStory()
                    }
                } label: {
                    VStack {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .padding(18)
                            .background(Circle().stroke(Color.gray))
                        Text("Добавить")
                            .foregroundStyle(Color.white)
                            .font(.caption)
                    }
                }
            }
            .padding()
        }
        .background(Color.backgroundColor)
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

//#Preview {
//    StoriesView()
//}
