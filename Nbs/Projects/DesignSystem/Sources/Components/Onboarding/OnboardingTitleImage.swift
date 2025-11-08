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
  
  public init(
    title: OnboardingNamespace,
    description: OnboardingNamespace,
    image: Image
  ) {
    self.title = title
    self.description = description
    self.image = image
  }
}

extension OnboardingTitleImage: View {
  public var body: some View {
    VStack(spacing: 0) {
      Text(title.rawValue)
        .font(.H2)
        .foregroundStyle(.text1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
      
      Text(description.rawValue)
        .font(.C1)
        .foregroundStyle(.caption2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
        .padding(.top, 8)
      
      image
        .resizable()
        .scaledToFit()
        .padding(.horizontal, 30)
        .padding(.top, 55)
    }
  }
}
