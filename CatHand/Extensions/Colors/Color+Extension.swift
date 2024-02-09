//
//  ColorExtension.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 10.01.2024.
//

import SwiftUI

public extension Color {
    
    static let mainGradientBackground = LinearGradient(gradient: Gradient(colors: [Color(uiColor: UIColor(hexString: "#E674A5")), Color(uiColor: UIColor(hexString: "#EA838A")), Color(uiColor: UIColor(hexString: "#FEAF86"))]), startPoint: .top, endPoint: .bottom)
    
    static let backgroundColor = Color(uiColor: UIColor(named: "BackgroundColor") ?? UIColor.red)
    static let blackOrWhiteColor = Color(uiColor: UIColor(named: "BlackOrWhite") ?? UIColor.red)
    static let whiteOrBackColor = Color(uiColor: UIColor(named: "WhiteOrBack") ?? UIColor.red)
}
