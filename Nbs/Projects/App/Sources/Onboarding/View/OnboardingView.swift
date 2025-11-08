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
  @Bindable var store: StoreOf<OnboardingFeature>
}

extension OnboardingView: View {
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        OnboardingTitleImage(
          title: .safariTitle,
          description: .safariDescription,
          image: DesignSystemAsset.onboardingService.swiftUIImage,
          showPage: true,
          currentPage: store.currentPage
        )
        .padding(.top, 72)
      }
      
      VStack {
        MainButton("설정하기", hasGradient: true) {
          store.send(.settingButtonTapped)
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
    .overlay {
      if store.isAlert {
        ZStack {
          Color.dim.ignoresSafeArea()
          AlertDialog(
            title: "Safari 권한 설정을 건너뛸까요?",
            subtitle: "권한을 설정하지 않으면\n제공하는 기능 사용이 제한돼요",
            cancelTitle: "취소",
            onCancel: { store.send(.alertCancelButtonTapped) },
            buttonType: .move(title: "건너뛰기", action: { store.send(.alertSkipButtonTapped) })
          )
        }
      }
    }
  }
}
