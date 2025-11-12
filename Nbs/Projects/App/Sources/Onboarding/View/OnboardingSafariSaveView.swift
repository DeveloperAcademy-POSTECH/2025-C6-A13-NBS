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
    VStack(spacing: 0) {
      TopAppBarDefaultRightIconx(title: "Safari에서 공유하기") {
        store.send(.backButtonTapped)
      }
      Group {
        Text("Safari에서 공유해 저장하는 과정을")
        Text("영상을 통해 확인해보세요")
      }
        .frame(maxWidth: .infinity, alignment: .center)
        .font(.B1_SB)
        .foregroundStyle(.caption1)
      
      Spacer()
      VStack {
        MainButton("완료", hasGradient: true) {
          store.send(.completeButtonTapped)
        }
        .buttonStyle(.plain)
      }
      .background(Color.background)
      .toolbar(.hidden)
    }
    .background(Color.background)
  }
}
