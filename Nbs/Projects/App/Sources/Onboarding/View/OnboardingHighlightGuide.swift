//
//  OnboardingHighlight.swift
//  Nbs
//
//  Created by 홍 on 11/8/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct OnboardingHighlightGuideView {
  let store: StoreOf<OnboardingHighlightFeature>
}

extension OnboardingHighlightGuideView: View {
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        TopAppBarDefaultRightIconx(title: "") {
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
        MainButton("다음", hasGradient: true) {
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
    }
    .background(Color.background)
    .toolbar(.hidden)
  }
}
