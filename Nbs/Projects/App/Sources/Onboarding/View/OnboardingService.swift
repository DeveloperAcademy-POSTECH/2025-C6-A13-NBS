//
//  OnboardingView.swift
//  Nbs
//
//  Created by 홍 on 11/7/25.
//

import SwiftUI

import DesignSystem
import LinkNavigator
import ComposableArchitecture

struct OnboardingServiceView {
  let store: StoreOf<OnboardingServiceFeature>
}

extension OnboardingServiceView: View {
  var body: some View {
    VStack {
      OnboardingTitleImage(
        title: .introTitle,
        description: .introDescription,
        image: DesignSystemAsset.onboardingService.swiftUIImage,
        showPage: false,
        currentPage: 0
      )
      .padding(.top, 60)
      
      Spacer()
      MainButton("시작하기", hasGradient: true) {
        store.send(.startButtonTapped)
      }
      .buttonStyle(.plain)
      .padding(.bottom, 8)
    }
    .background(Color.background)
    .toolbar(.hidden)
  }
}
