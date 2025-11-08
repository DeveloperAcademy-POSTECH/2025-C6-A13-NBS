//
//  OnboardingHighlightTip.swift
//  DesignSystem
//
//  Created by 홍 on 11/8/25.
//

import SwiftUI

public struct OnboardingHighlightTip {
  @State private var selectedIndex: Int? = nil
  
  public init(selectedIndex: Int? = nil) {
    self.selectedIndex = selectedIndex
  }
}

extension OnboardingHighlightTip: View {
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 6) {
        Button(action: { selectedIndex = 0 }) {
          Capsule()
            .fill(.chipPink)
            .overlay(
              Capsule().strokeBorder(
                selectedIndex == 0 ? .chipPinkLine : .stateDefaultLine,
                lineWidth: 2
              )
            )
            .frame(width: 50, height: 40)
        }
        Button(action: { selectedIndex = 1 }) {
          Capsule()
            .fill(.chipYellow)
            .overlay(
              Capsule().strokeBorder(
                selectedIndex == 1 ? .chipYellowLine : .stateDefaultLine,
                lineWidth: 2
              )
            )
            .frame(width: 50, height: 40)
        }
        Button(action: { selectedIndex = 2 }) {
          Capsule()
            .fill(.chipBlue)
            .overlay(
              Capsule().strokeBorder(
                selectedIndex == 2 ? .chipBlueLine : .stateDefaultLine,
                lineWidth: 2
              )
            )
            .frame(width: 50, height: 40)
        }
        Button(action: { selectedIndex = 3 }) {
          ZStack {
            Capsule()
              .fill(Color.chipMemo)
              .overlay(
                Capsule().strokeBorder(
                  selectedIndex == 3 ? .stateDefaultLine : .stateDefaultLine,
                  lineWidth: 2
                )
              )
            DesignSystemAsset.memo.swiftUIImage
              .resizable()
              .renderingMode(.template)
              .foregroundStyle(.chipMemoIcon)
              .frame(width: 16, height: 16)
          }
          .frame(width: 50, height: 40)
        }
      }
      .padding(.all, 4)
      .background(.stateTooltipbackground)
      .clipShape(RoundedRectangle(cornerRadius: 30))
      Triangle()
        .fill(.stateTooltipbackground)
        .frame(width: 16, height: 10)
    }
    .shadow(color: Color(red: 0.22, green: 0.2, blue: 0.37).opacity(0.07), radius: 3, x: 0, y: 2)
    .shadow(color: Color(red: 0.32, green: 0.32, blue: 0.43).opacity(0.25), radius: 10, x: 0, y: 0)
  }
}

#Preview {
  OnboardingHighlightTip()
}

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
