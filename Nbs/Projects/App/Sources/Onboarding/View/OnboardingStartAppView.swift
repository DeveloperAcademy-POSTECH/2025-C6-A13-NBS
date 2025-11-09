//
//  OnboardingStartAppView.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

public struct OnboardingStartAppView {
  @Dependency(\.linkNavigator) var navigation
}

extension OnboardingStartAppView: View {
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 8) {
        Text("TapTap 시작하기")
          .font(.H2)
          .foregroundStyle(.text1)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 20)
      
      Text("읽고, 밑줄 긋고, 기록하며 만들어가는 시사 습관\nTapTap을 통해 만들어가요")
        .font(.C1)
        .foregroundStyle(.caption2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
        .padding(.top, 8)
      
      DesignSystemAsset.onboardingService.swiftUIImage
        .resizable()
        .scaledToFit()
        .padding(.horizontal, 30)
        .padding(.top, 55)
      MainButton("시작하기") {
        navigation.push(.home, nil)
      }
    }
  }
}
