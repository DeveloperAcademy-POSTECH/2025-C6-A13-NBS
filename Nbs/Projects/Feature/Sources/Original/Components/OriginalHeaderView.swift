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
  enum HeaderType {
    case edit
    case article
  }
  
  @Environment(\.dismiss) var dismiss
  
  let headerType: HeaderType
  let onEditTapped: (() -> Void)?
  let onCompleteTapped: (() -> Void)?
  
  // 초기화 시점에 기본값 설정
  init(headerType: HeaderType, onEditTapped: (() -> Void)? = nil, onCompleteTapped: (() -> Void)? = nil) {
    self.headerType = headerType
    self.onEditTapped = onEditTapped
    self.onCompleteTapped = onCompleteTapped
  }
}

// MARK: - View
extension OriginalHeaderView {
  var body: some View {
    HStack {
      Button {
        dismiss()
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
        switch headerType {
        case .edit:
          onCompleteTapped?()
        case .article:
          onEditTapped?()
        }
      } label: {
        Text(headerType == .edit ? "완료" : "수정")
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
  VStack {
    OriginalHeaderView(headerType: .article, onEditTapped: {})
    OriginalHeaderView(headerType: .edit, onCompleteTapped: {}) 
  }
}
