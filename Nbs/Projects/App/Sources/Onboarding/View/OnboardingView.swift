//
//  OnboardingSafariSetting.swift
//  Nbs
//
//  Created by 홍 on 11/7/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct OnboardingView {
  let store: StoreOf<OnboardingFeature>
}

extension OnboardingView: View {
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack {
        TopAppBarDefaultRightIconx(title: "") {
          store.send(.backButtonTapped)
        }
        OnboardingTitleImage(
          title: .safariTitle,
          description: .safariDescription,
          image: DesignSystemAsset.onboardingService.swiftUIImage
        )
      }

      MainButton("시작하기", hasGradient: true) {
        store.send(.startButtonTapped)
      }
      .buttonStyle(.plain)
    }
    .background(Color.background)
    .toolbar(.hidden)
  }
}
