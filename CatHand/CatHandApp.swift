//
//  CatHandApp.swift
//  CatHand
//
//  Created by Филатов Олег Олегович on 09.02.2024.
//

import SwiftUI

@main
struct CatHandApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.colorScheme, .dark)
        }
    }
}
