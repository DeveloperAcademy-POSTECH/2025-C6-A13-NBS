//
//  ChipButton.swift
//  DesignSystem
//
//  Created by 이안 on 10/16/25.
//

import SwiftUI

/// 선택 토글이 가능한 칩 버튼 컴포넌트
///
/// 디자인 시스템에 맞춘 칩 형태의 토글 버튼으로,
/// `deep`(진한색) 또는 `soft`(연한색) 스타일을 지원
/// 선택 여부(`isOn`)에 따라 배경색과 테두리 색상이 자동으로 변경
///
/// - Parameters:
///   - title: 칩에 표시할 텍스트
///   - style: 칩 스타일 (`.deep` 또는 `.soft`)
///   - isOn: 선택 상태를 나타내는 바인딩 값
///   - onTap: 선택 토글 후 실행할 클로저 (선택사항)
public struct ChipButton: View {
  
  // MARK: Style
  public enum Style {
    case deep  // 진한색 버튼
    case soft  // 연한색 버튼
  }
  
  // MARK: - Properties
  let title: String
  let style: Style
  
  /// 현재 선택 상태
  @Binding var isOn: Bool
  
  /// 탭 콜백(선택 토글 후 호출)
  var onTap: (() -> Void)?
  
  // MARK: - Init
  public init(
    title: String,
    style: Style,
    isOn: Binding<Bool>,
    onTap: (() -> Void)? = nil
  ) {
    self.title = title
    self.style = style
    self._isOn = isOn
    self.onTap = onTap
  }
  
  // MARK: - Colors
  private var backgroundColor: Color {
    switch style {
    case .deep: return isOn ? .bl6 : .n40
    case .soft: return isOn ? .bl1 : .clear
    }
  }
  
  private var textColor: Color {
    switch style {
    case .deep: return isOn ? .textw : .caption2
    case .soft: return isOn ? .bl6 : .caption1
    }
  }
  
  private var borderColor: Color {
    switch style {
    case .deep:
      return isOn ? .bl6 : .n40
    case .soft:
      return isOn ? .bl6 : .divider2
    }
  }
}

// MARK: - Body
public extension ChipButton {
  var body: some View {
    Button {
      withAnimation() { isOn.toggle() }
      onTap?()
    } label: {
      Text(title)
        .font(.B2_SB)
        .foregroundStyle(textColor)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(minHeight: 36)
        .background(
          RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(backgroundColor)
        )
        .overlay(
          RoundedRectangle(cornerRadius: 24, style: .continuous)
            .stroke(borderColor, lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
    .buttonStyle(.plain)
  }
}

// MARK: - Preview
private struct ChipButtonPreview: View {
  @State private var isSoftOn = false
  @State private var isDeepOn = true
  
  var body: some View {
    HStack(spacing: 12) {
      ChipButton(title: "텍스트", style: .soft, isOn: $isSoftOn)
      ChipButton(title: "텍스트", style: .deep, isOn: $isDeepOn)
    }
  }
}

#Preview {
  ChipButtonPreview()
}

