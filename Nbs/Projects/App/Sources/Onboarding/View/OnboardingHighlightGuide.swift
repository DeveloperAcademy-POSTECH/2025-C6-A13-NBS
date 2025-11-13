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
  let store: StoreOf<OnboardingHighlightGuideFeature>
}

extension OnboardingHighlightGuideView: View {
  var body: some View {
    VStack(spacing: 0) {
      TopAppBarDefaultRightIconx(title: "") {
        store.send(.backButtonTapped)
      }
      OnboardingTitleImage(
        title: .highlightMemoTitle,
        description: .highlightMemoDescription,
        image: DesignSystemAsset.highlightMemo.swiftUIImage,
        showPage: true,
        currentPage: store.currentPage
      )
      Spacer()
      VStack(spacing: 0) {
        MainButton("다음", hasGradient: true) {
          store.send(.nextButtonTapped)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 24)
        
        Button(action: {
          store.send(.skipButtonTapped)
        }) {
          Text("건너뛰기")
            .font(.C2)
            .foregroundStyle(.caption2)
            .underline()
        }
      }
      .background(Color.background)
      .padding(.bottom, 8)
    }
    .background(Color.background)
    .toolbar(.hidden)
  }
}
