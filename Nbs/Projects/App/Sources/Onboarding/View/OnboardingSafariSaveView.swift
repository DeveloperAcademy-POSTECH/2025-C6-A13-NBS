//
//  OnboardingSaveView.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct OnboardingSafariSaveView {
  let store: StoreOf<OnboardingSafariSaveFeature>
}

extension OnboardingSafariSaveView: View {
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        TopAppBarDefaultRightIconx(title: "Safari에서 공유하기") {
          store.send(.backButtonTapped)
        }
        OnboardingTitleImage(
          title: .highlightMemoTitle,
          description: .highlightMemoDescription,
          image: DesignSystemAsset.onboardingService.swiftUIImage,
          showPage: true,
          currentPage: store.currentPage
        )
        .padding(.top, 16)
      }
      
      VStack {
        MainButton("완료", hasGradient: true) {
          store.send(.completeButtonTapped)
        }
        .buttonStyle(.plain)
      }
      .background(Color.background)
    }
    .background(Color.background)
    .toolbar(.hidden)
  }
}
