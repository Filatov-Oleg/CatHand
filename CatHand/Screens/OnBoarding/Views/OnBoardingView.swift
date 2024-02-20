//
//  OnBoardingView.swift
//  CatHand
//
//  Created by Филатов Олег Олегович on 12.02.2024.
//

import SwiftUI

struct OnBoardingView: View {
    
    let model: OnBoardingModel
    var onTapNext: () -> ()
    var onTapSkip: () -> ()
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Image(model.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.size.width * 0.8)
                Spacer()
            }
            .padding(.leading, 16)
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 12) {
                    Button {
                        withAnimation {
                            onTapNext()
                        }
                    } label: {
                        Text(model.nextButton)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.mainGradientBackground)
                            .padding(8)
                            .padding(.horizontal, 2)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.mainGradientBackground)
                            }
                    }
                    if !model.skipButton.isEmpty {
                        Button {
                            withAnimation {
                                onTapSkip()
                            }
                        } label: {
                            Text(model.skipButton)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                                .padding(8)
                                .padding(.horizontal, 2)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray)
                                }
                        }
                    }
                }
                .padding(.trailing, 16)
            }

        }
        .background(Color.backgroundColor)
    }
}

//#Preview {
//    OnBoardingView()
//}
