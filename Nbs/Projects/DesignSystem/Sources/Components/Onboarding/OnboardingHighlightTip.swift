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
                Capsule()
                  .strokeBorder(.stateDefaultLine, lineWidth: 2)
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
      .shadow(color: Color.bgShadow4, radius: 3, x: 0, y: 2)
      .shadow(color: Color.bgShadow5, radius: 10, x: 0, y: 0)
      Triangle()
        .fill(.stateTooltipbackground)
        .frame(width: 16, height: 10)
        .shadow(color: Color.bgShadow4, radius: 8, x: 0, y: 6)
        .shadow(color: Color.bgShadow5, radius: 4, x: 0, y: 6)
    }
//    .shadow(color: Color.bgShadow4, radius: 3, x: 0, y: 2)
//    .shadow(color: Color.bgShadow5, radius: 10, x: 0, y: 0)
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
  var cornerRadius: CGFloat = 2
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let top = CGPoint(x: rect.midX, y: rect.maxY)
    let bottomLeft = CGPoint(x: rect.minX, y: rect.minY)
    let bottomRight = CGPoint(x: rect.maxX, y: rect.minY)
    
    path.move(to: bottomLeft)
    
    path.addArc(
      tangent1End: top,
      tangent2End: bottomRight,
      radius: cornerRadius
    )
    
    path.addLine(to: bottomRight)
    path.addLine(to: bottomLeft)
    
    path.closeSubpath()
    return path
  }
}
