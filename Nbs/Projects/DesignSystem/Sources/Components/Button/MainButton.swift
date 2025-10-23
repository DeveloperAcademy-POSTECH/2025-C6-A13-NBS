//
//  MainButton.swift
//  DesignSystem
//
//  Created by 이안 on 10/15/25.
//

import SwiftUI

/// 공통 메인 버튼 컴포넌트
///
/// 디자인 시스템에 맞춘 기본 버튼으로, 진한색(.deep) 또는 연한색(.soft) 스타일을 선택할 수 있으며, 비활성화 상태도 지원
///
/// - Parameters:
///   - title: 버튼에 표시할 텍스트
///   - style: 버튼의 색상 스타일 - 기본값 `.deep`
///   - isDisabled: 버튼을 비활성화할지 여부 - 기본값 `false`
///   - action: 버튼이 눌렸을 때 실행할 액션
public struct MainButton: View {
  
  // MARK: - Style
  public enum Style {
    case deep   // 진한색 버튼
    case soft   // 연한색 버튼
    case danger // 삭제용 빨간색
  }
  
  // MARK: - Properties
  let title: String
  let style: Style
  let isDisabled: Bool
  let action: () -> Void
  
  // MARK: - Init
  public init(
    _ title: String,
    style: Style = .deep,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.style = style
    self.isDisabled = isDisabled
    self.action = action
  }
  
  // MARK: - Color
  private var backgroundColor: Color {
    switch style {
    case .deep:
      return isDisabled
      ? .n30 : .bl6
    case .soft:
      return isDisabled
      ? .n30 : .bl1
    case .danger:
      return isDisabled
      ? .n30 : .danger
    }
  }
  
  private var foregroundColor: Color {
    switch style {
    case .deep:
      return isDisabled
      ? .caption2 : .textw
    case .soft:
      return isDisabled
      ? .caption2 : .bl6
    case .danger:
      return isDisabled
      ? .caption2 : .textw
    }
  }
}

// MARK: - Body
extension MainButton {
  public var body: some View {
    Button(action: action) {
      Text(title.uppercased())
        .font(.B1_SB)
        .foregroundStyle(foregroundColor)
        .frame(maxWidth: .infinity, minHeight: 52)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .disabled(isDisabled)
  }
}

// MARK: - Preview
#Preview {
  MainButton(
    "BUTTON",
    style: .deep,
    isDisabled: false
  ) { print("버튼입니다") }
}
