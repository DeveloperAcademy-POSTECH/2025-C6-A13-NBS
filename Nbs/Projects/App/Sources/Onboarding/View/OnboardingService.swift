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
      ZStack(alignment: .bottom) {
        OnboardingTitleImage(
          title: .introTitle,
          description: .introDescription,
          image: DesignSystemAsset.onboardingService.swiftUIImage
        )
        .padding(.top, 72)
        
        MainButton("시작하기", hasGradient: true) {
          store.send(.startButtonTapped)
        }
        .buttonStyle(.plain)
      }
    }
    .background(Color.background)
    .toolbar(.hidden)
  }
}

//#Preview {
//  OnboardingServiceView()
//}
