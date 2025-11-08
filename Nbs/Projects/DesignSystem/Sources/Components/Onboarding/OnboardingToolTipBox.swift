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

#Preview(body: {
  OnboardingToolTipBox(text: "하이라이트 치는 방법을 배워볼게요")
})
