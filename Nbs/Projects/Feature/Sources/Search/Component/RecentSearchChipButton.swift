//
//  RecentSearchChipButton.swift
//  Feature
//
//  Created by 여성일 on 10/19/25.
//

import SwiftUI

import DesignSystem

// MARK: - Properties
struct RecentSearchChipButton: View {
  let title: String
  let chipTouchAction: () -> Void
  let deleteAction: () -> Void
}

// MARK: - View
extension RecentSearchChipButton {
  var body: some View {
    Button {
      chipTouchAction()
    } label: {
      HStack(spacing: 4) {
        Text(title)
          .font(.B1_M)
          .foregroundStyle(.caption1)
          .lineLimit(1)
          .multilineTextAlignment(.center)
        Button {
          deleteAction()
        } label: {
          Image(icon: Icon.x)
            .renderingMode(.template)
            .foregroundStyle(.iconDisabled)
        }
      }
    }
    .padding(.leading, 18)
    .padding(.trailing, 12)
    .padding(.vertical, 8)
    .background(.clear)
    .clipShape(.capsule)
    .overlay {
      RoundedRectangle(cornerRadius: 100)
        .stroke(.divider2, lineWidth: 1)
    }
  }
}
