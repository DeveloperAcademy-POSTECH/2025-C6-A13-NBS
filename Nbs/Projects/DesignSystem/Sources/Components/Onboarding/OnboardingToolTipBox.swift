//
//  OnboardingTooltipBox.swift
//  DesignSystem
//
//  Created by 홍 on 11/8/25.
//

import SwiftUI

public struct OnboardingToolTipBox {
  let text: String
  
  public init(text: String) {
    self.text = text
  }
}

extension OnboardingToolTipBox: View {
  public var body: some View {
    VStack(spacing: 0) {
      
      Triangle()
        .rotation(.degrees(180))
        .fill(.bl6)
        .frame(width: 16, height: 10)
      
      Text(text)
        .font(.B1_M_HL)
        .foregroundStyle(.textw)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 4)
            .fill(.bl6)
        )
      
      //      Triangle()
      //        .fill(.bl6)
      //        .frame(width: 16, height: 10)
    }
  }
}

// MARK: - Triangle Shape
fileprivate struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    path.closeSubpath()
    return path
  }
}

public struct OnboardingToolTipBoxBottom {
  let text: String
  
  public init(text: String) {
    self.text = text
  }
}

extension OnboardingToolTipBoxBottom: View {
  public var body: some View {
    VStack(spacing: 0) {
      Text(text)
        .font(.B1_M_HL)
        .foregroundStyle(.textw)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 4)
            .fill(.bl6)
        )
      Triangle()
        .fill(.bl6)
        .frame(width: 16, height: 10)
    }
  }
}

public struct OnboardingToolTipBoxBottomTrailing {
  let text: String
  
  public init(text: String) {
    self.text = text
  }
}

extension OnboardingToolTipBoxBottomTrailing: View {
  public var body: some View {
    VStack(spacing: 0) {
      Text(text)
        .font(.B1_M_HL)
        .foregroundStyle(.textw)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 4)
            .fill(.bl6)
        )
        .overlay(alignment: .bottomTrailing) {
          Triangle()
            .fill(.bl6)
            .frame(width: 18, height: 12)
            .padding(.trailing, 14)
            .padding(.bottom, -15)
        }
    }
  }
}

public struct OnboardingToolTipBoxTopLeading {
  let text: String
  
  public init(text: String) {
    self.text = text
  }
}

extension OnboardingToolTipBoxTopLeading: View {
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Triangle()
        .rotation(.degrees(180))
        .fill(.bl6)
        .frame(width: 16, height: 10)
        .padding(.leading, 14) // 텍스트 padding과 정렬 포인트! ✨

      Text(text)
        .font(.B1_M_HL)
        .foregroundStyle(.textw)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 4)
            .fill(.bl6)
        )
    }
  }
}

#Preview {
  OnboardingToolTipBoxTopLeading(text: "g하이g하이g하이g하이g하이")
}
