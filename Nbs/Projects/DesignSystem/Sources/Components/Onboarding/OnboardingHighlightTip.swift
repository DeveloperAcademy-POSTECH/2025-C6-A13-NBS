//
//  OnboardingHighlightTip.swift
//  DesignSystem
//
//  Created by 홍 on 11/8/25.
//

import SwiftUI

public struct OnboardingHighlightTip {
  @Binding var selectedColor: Color
  var onMemoTapped: () -> Void
  
  public init(selectedColor: Binding<Color>, onMemoTapped: @escaping () -> Void) {
    self._selectedColor = selectedColor
    self.onMemoTapped = onMemoTapped
  }
}

extension OnboardingHighlightTip: View {
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 6) {
        Button(action: { selectedColor = .chipPink }) {
          Capsule()
            .fill(.chipPink)
            .overlay(
              Capsule().strokeBorder(
                selectedColor == .chipPink ? .chipPinkLine : .stateDefaultLine,
                lineWidth: 2
              )
            )
            .frame(width: 50, height: 40)
        }
        Button(action: { selectedColor = .chipYellow }) {
          Capsule()
            .fill(.chipYellow)
            .overlay(
              Capsule().strokeBorder(
                selectedColor == .chipYellow ? .chipYellowLine : .stateDefaultLine,
                lineWidth: 2
              )
            )
            .frame(width: 50, height: 40)
        }
        Button(action: { selectedColor = .chipBlue }) {
          Capsule()
            .fill(.chipBlue)
            .overlay(
              Capsule().strokeBorder(
                selectedColor == .chipBlue ? .chipBlueLine : .stateDefaultLine,
                lineWidth: 2
              )
            )
            .frame(width: 50, height: 40)
        }
        Button(action: onMemoTapped) {
          ZStack {
            Capsule()
              .fill(Color.chipMemo)
              .overlay(
                Capsule().strokeBorder(
                  .stateDefaultLine,
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
  struct PreviewWrapper: View {
    @State private var color: Color = .chipPink
    var body: some View {
      OnboardingHighlightTip(selectedColor: $color, onMemoTapped: {})
    }
  }
  return PreviewWrapper()
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
