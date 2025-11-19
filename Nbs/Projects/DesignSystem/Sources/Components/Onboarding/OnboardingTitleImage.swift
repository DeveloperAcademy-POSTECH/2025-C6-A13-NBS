//
//  Onboarding.swift
//  DesignSystem
//
//  Created by 홍 on 11/7/25.
//

import SwiftUI

public struct OnboardingTitleImage {
  let title: OnboardingNamespace
  let description: OnboardingNamespace
  let image: Image
  let showPage: Bool
  let currentPage: Int
  
  public init(
    title: OnboardingNamespace,
    description: OnboardingNamespace,
    image: Image,
    showPage: Bool,
    currentPage: Int
  ) {
    self.title = title
    self.description = description
    self.image = image
    self.showPage = showPage
    self.currentPage = currentPage
  }
}

extension OnboardingTitleImage: View {
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 8) {
        Text(title.rawValue)
          .font(.H2)
          .foregroundStyle(.text1)
        if showPage {
          Text("\(currentPage)/\(3)")
            .font(.C2)
            .foregroundStyle(.caption1)
            .offset(y: 5)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 20)
      
      Text(description.rawValue)
        .font(.C1)
        .foregroundStyle(.caption2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
        .padding(.top, 8)
      
      if image == DesignSystemAsset.onboardingService.swiftUIImage {
        DesignSystemAsset.onboardingService.swiftUIImage
          .resizable()
          .scaledToFit()
          .padding(.horizontal, 30)
          .padding(.top, 60)
      } else {
        image
          .resizable()
          .scaledToFit()
          .padding(.horizontal, 56)
          .padding(.top, 60)      }
    }
    .background(Color.background)
  }
}

#Preview(
  body: {
    OnboardingTitleImage(
      title: .highlightMemoTitle,
      description: .highlightMemoDescription,
      image: DesignSystemAsset.onboardingService.swiftUIImage,
      showPage: true,
      currentPage: 1
    )
})
