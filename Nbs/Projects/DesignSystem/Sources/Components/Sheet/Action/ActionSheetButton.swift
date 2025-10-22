//
//  ActionSheetButton.swift
//  DesignSystem
//
//  Created by 이안 on 10/21/25.
//

import SwiftUI

public struct ActionSheetButton: View {
  public enum Style {
    case normal, danger
  }

  let icon: String
  let title: String
  let style: Style
  let action: () -> Void

  public init(icon: String, title: String, style: Style = .normal, action: @escaping () -> Void) {
    self.icon = icon
    self.title = title
    self.style = style
    self.action = action
  }
}

extension ActionSheetButton {
  public var body: some View {
    Button(action: action) {
      HStack {
        Image(icon: icon)
          .renderingMode(.template)
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(style == .danger ? .danger : .icon)
          .padding(.trailing, 10)
        Text(title)
          .font(.B1_M)
          .foregroundStyle(style == .danger ? .danger : .text1)
      }
      .padding(.leading, 20)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .buttonStyle(.plain)
  }
}
