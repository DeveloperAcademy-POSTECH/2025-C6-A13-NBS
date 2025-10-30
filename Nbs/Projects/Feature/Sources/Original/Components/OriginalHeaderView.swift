//
//  OriginalHeaderView.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import SwiftUI

import DesignSystem

// MARK: - Properties
struct OriginalHeaderView: View {
  @State var isOn = true
}

// MARK: - View
extension OriginalHeaderView {
  var body: some View {
    HStack {
      Button {
        
      } label: {
        Image(icon: Icon.chevronLeft)
          .renderingMode(.template)
          .foregroundStyle(.icon)
          .frame(width: 24, height: 24)
          .padding(10)
      }
      .padding(.leading, 4)
      .contentShape(Rectangle())
      Spacer()
      Button {
        
      } label: {
        Text("수정")
          .font(.B2_SB)
          .foregroundStyle(.textw)
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .background(.bl6)
          .clipShape(.capsule)
      }
      .buttonStyle(.plain)
      .padding(.trailing, 20)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 8)
  }
}

#Preview {
  OriginalHeaderView()
}
