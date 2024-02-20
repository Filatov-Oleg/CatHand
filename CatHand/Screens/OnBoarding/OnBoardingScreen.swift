//
//  OnBoardingScreen.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 08.02.2024.
//

import SwiftUI
import PhotosUI

struct OnBoardingScreen: View {
    
    @Binding var onboardingWasViewed: Bool
    
    @State private var currentTab = 0
    
    var body: some View {
        TabView(selection: $currentTab,
                content:  {
            OnBoardingView(model: .init(image: "onboarding1", nextButton: "ДА, ПОКАЖИ", skipButton: "ПРОПУСТИТЬ"), onTapNext: {
                currentTab = 1
            }, onTapSkip: {
                currentTab = 5
            })
            .tag(0)
            OnBoardingView(model: .init(image: "onboarding2", nextButton: "ДАЛЬШЕ!", skipButton: "ПРОПУСТИТЬ"), onTapNext: {
                currentTab = 2
            }, onTapSkip: {
                currentTab = 5
            })
            .tag(1)
            OnBoardingView(model: .init(image: "onboarding3", nextButton: "ДАЛЬШЕ!", skipButton: "ПРОПУСТИТЬ"), onTapNext: {
                currentTab = 3
            }, onTapSkip: {
                currentTab = 5
            })
            .tag(2)
            OnBoardingView(model: .init(image: "onboarding4", nextButton: "ДАЛЬШЕ!", skipButton: "ПРОПУСТИТЬ"), onTapNext: {
                currentTab = 4
            }, onTapSkip: {
                currentTab = 5
            })
            .tag(3)
            OnBoardingView(model: .init(image: "onboarding5", nextButton: "ВСЕ ПОНЯТНО!", skipButton: "ПОВТОРИТЬ"), onTapNext: {
                currentTab = 5
            }, onTapSkip: {
                currentTab = 0
            })
            .tag(4)
            OnBoardingView(model: .init(image: "onboarding6", nextButton: "НАЧАТЬ", skipButton: ""), onTapNext: {
                UserDefaultsService().onboardingWasViewed = true
                onboardingWasViewed = true
            }, onTapSkip: {
                
            })
            .tag(5)
        })
        .background(Color.backgroundColor)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

}
//
//#Preview {
//    OnBoardingScreen()
//}
