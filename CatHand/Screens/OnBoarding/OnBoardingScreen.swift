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
    
    var body: some View {
        VStack {
            Text("Для корректной работы приложение предоставье доступ к библиотеке фотографий")
            Button {
                requestPhotoLibraryAccess()
            } label: {
                Text("Разрешить доступ")
            }
        }
    }
    
    private func requestPhotoLibraryAccess() {
      let status = PHPhotoLibrary.authorizationStatus()

      switch status {
      case .notDetermined:
        PHPhotoLibrary.requestAuthorization { newStatus in
          if newStatus == .authorized {
            print("Access granted.")
            UserDefaultsService().onboardingWasViewed = true
            onboardingWasViewed = true
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
//
//#Preview {
//    OnBoardingScreen()
//}
