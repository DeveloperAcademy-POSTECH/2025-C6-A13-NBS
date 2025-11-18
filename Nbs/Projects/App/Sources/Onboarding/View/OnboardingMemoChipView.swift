//
//  OnboardingMemoChipView.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import SwiftUI

import DesignSystem

struct MemoChipView {
  @Binding var selectedColor: Color
  @State private var showTooltip = true
}

extension MemoChipView: View {
  var body: some View {
    VStack {
      HStack {
        Text("하이라이트 문장을...")
          .lineLimit(1)
          .font(.B2_M)
          .foregroundStyle(strokeColor)
        Spacer()
        DesignSystemAsset.x.swiftUIImage
          .resizable()
          .renderingMode(.template)
          .frame(width: 24, height: 24)
          .foregroundStyle(.iconGray)
      }
      .padding(.horizontal, 12)
      .frame(width: 167, height: 40)
      .background(
        Capsule()
          .fill(selectedColor)
      )
      .overlay(
        Capsule()
          .stroke(strokeColor, lineWidth: 1)
      )
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 20)
      OnboardingToolTipBoxTopLeading(text: "해당 메모 하단에 메모칩이 생성돼요")
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 53)
      }
  }
}

extension MemoChipView {
  private var strokeColor: Color {
    switch selectedColor {
    case .chipBlue:
      return .chipBlueLine
    case .chipYellow:
      return .chipYellowLine
    case .chipPink:
      return .chipPinkLine
    default:
      return .chipPinkLine
    }
  }
}
