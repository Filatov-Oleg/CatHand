//
//  SnackView.swift
//  CatHand
//
//  Created by Филатов Олег Олегович on 17.02.2024.
//

import SwiftUI

struct SnackbarView: View {
    var snackTitle: String
    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 4) {
                Text(snackTitle)
                    .foregroundColor(Color.white)
                    .font(.headline)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.mainGradientBackground.opacity(0.8))
        .mask {
            RoundedRectangle(cornerRadius: 12)
        }
        .padding()
    }
}
