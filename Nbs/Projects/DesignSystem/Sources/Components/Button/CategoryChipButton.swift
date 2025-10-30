//
//  CategoryChipButton.swift
//  DesignSystem
//
//  Created by 홍 on 10/28/25.
//

import SwiftUI

/// 선택이 가능한 카테고리 칩 버튼 컴포넌트
///
/// 디자인 시스템에 맞춘 칩 형태의 토글 버튼으로,
///
/// - Parameters:
///   - title: 칩에 표시할 텍스트
///   - image: 칩에 표시할 이미지
public struct CategoryChipButton {
  
  // MARK: - Properties
  let categoryType: Int
  let title: String
  
  /// 탭 콜백(선택 토글 후 호출)
  var onTap: (() -> Void)?
  
  // MARK: - Init
  public init(
    title: String,
    categoryType: Int,
    onTap: (() -> Void)? = nil
  ) {
    self.title = title
    self.categoryType = categoryType
    self.onTap = onTap
  }
}

// MARK: - Body
extension CategoryChipButton: View {
  public var body: some View {
    Button {
      onTap?()
    } label: {
      HStack(spacing: 12) {
        DesignSystemAsset.categoryIcon(number: categoryType)
          .resizable()
          .frame(width: 28, height: 28)
        Text(title)
          .font(.B1_SB)
          .foregroundStyle(.text1)
          .frame(minHeight: 36)
      }
      .padding(.leading)
      .padding(.vertical, 12)
      .padding(.trailing, 20)
      .background(
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(DesignSystemAsset.color(number: categoryType))
      )
      .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
      .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    .buttonStyle(.plain)
  }
}

// MARK: - Preview
private struct CategoryChipButtonPreview: View {
  
  var body: some View {
    HStack(spacing: 12) {
      CategoryChipButton(title: "안녕하세요", categoryType: 1) {
        print("")
      }
      
      CategoryChipButton(title: "", categoryType: 1) {
        print("")
      }
    }
  }
}

#Preview {
  CategoryChipButtonPreview()
}
