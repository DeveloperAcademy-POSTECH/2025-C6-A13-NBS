//
//  OnboardingSafariShareView.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct OnboardingSafariShareView {
  let store: StoreOf<OnboardingSafariShareFeature>
}

extension OnboardingSafariShareView: View {
  var body: some View {
    VStack(spacing: 0) {
      TopAppBarDefaultRightIconx(title: "") {
        store.send(.backButtonTapped)
      }
      OnboardingTitleImage(
        title: .safariShareTitle,
        description: .safariShareDescription,
        image: DesignSystemAsset.onboardingService.swiftUIImage,
        showPage: true,
        currentPage: store.currentPage
      )
      .padding(.top, 16)
      
      Spacer()
      VStack {
        MainButton("저장 방법 알아보기", hasGradient: true) {
          store.send(.nextButtonTapped)
        }
        .buttonStyle(.plain)
        
        Button(action: {
          store.send(.skipButtonTapped)
        }) {
          Text("건너뛰기")
            .font(.C2)
            .foregroundStyle(.caption2)
            .underline()
        }
        .padding(.top, 8)
      }
      .background(Color.background)
      .toolbar(.hidden)
    }
    .background(Color.background)
  }
}
