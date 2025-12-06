//
//  SaveLottieView.swift
//  ActionExtension
//
//  Created by 여성일 on 11/17/25.
//

import SwiftUI
import DesignSystem

// MARK: - Properties
struct SaveLottieView: View {
}

// MARK: - View
extension SaveLottieView {
  var body: some View {
    ZStack {
      Color.clear.ignoresSafeArea(.all)
      LottieWrapperView(animationName: "SaveSuccess")
        .frame(width: 160, height: 160)
        .background(.n0)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
  }
}

#Preview {
  SaveLottieView()
}
