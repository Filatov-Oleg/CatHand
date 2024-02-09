//
//  MainScreen.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 08.02.2024.
//

import SwiftUI

struct MainScreen: View {
    
    @State var onboardingWasViewed: Bool = UserDefaultsService().onboardingWasViewed
    
    var body: some View {
        ZStack {
            if onboardingWasViewed == false {
                OnBoardingScreen(onboardingWasViewed: $onboardingWasViewed)
            } else {
                ContentView()
            }
        }
    }
}

#Preview {
    MainScreen()
}
