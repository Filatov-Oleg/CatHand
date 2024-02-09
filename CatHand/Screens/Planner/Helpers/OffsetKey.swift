//
//  OffsetKey.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 11.01.2024.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

