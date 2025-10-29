//
//  MakeNewCategoryButton.swift
//  DesignSystem
//
//  Created by 홍 on 10/29/25.
//

import SwiftUI

/// 새로운 카테고리 칩 버튼 컴포넌트
///
/// 디자인 시스템에 맞춘 버튼
///
public struct MakeNewCategoryButton {
  
  /// 탭 콜백(선택 토글 후 호출)
  var onTap: (() -> Void)?
  
  // MARK: - Init
  public init(
    onTap: (() -> Void)? = nil
  ) {
    self.onTap = onTap
  }
}

// MARK: - Body
extension MakeNewCategoryButton: View {
  public var body: some View {
    Button {
      onTap?()
    } label: {
      HStack(spacing: 12) {
        DesignSystemAsset.categoryIcon(number: 14)
          .resizable()
          .frame(width: 28, height: 28)
        Text("새 카테고리 만들기")
          .font(.B1_SB)
          .foregroundStyle(.text1)
          .frame(minHeight: 36)
        Spacer()
        Text("→")
          .font(.B1_SB)
          .foregroundStyle(.text1)
      }
      .padding(.leading)
      .padding(.vertical, 12)
      .padding(.trailing, 20)
      .background(
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(.bl2)
      )
      .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
      .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    .buttonStyle(.plain)
  }
}
