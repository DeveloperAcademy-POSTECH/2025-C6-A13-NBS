//
//  CheckboxButton.swift
//  DesignSystem
//
//  Created by 이안 on 10/16/25.
//

import SwiftUI

/// 원형 체크박스 버튼 컴포넌트
///
/// 토글 가능한 원형 버튼으로, 선택 여부(`isOn`)에 따라 색상과 아이콘이 변경
///
/// - Parameters:
///   - isOn: 현재 선택 상태 (Binding)
///   - style: 표시 스타일 (.dim / .clear)
///   - onTap: 선택 상태 변경 후 실행할 클로저 (선택)
public struct CheckboxButton: View {
  
  // MARK: Style
  public enum Style {
     case dim
     case clear
   }
  
  // MARK: - Properties
  @Binding var isOn: Bool
  private let style: Style
  private let onTap: (() -> Void)?
  
  // MARK: - Init
  public init(
    isOn: Binding<Bool>,
    style: Style = .dim,
    onTap: (() -> Void)? = nil
  ) {
    self._isOn = isOn
    self.style = style
    self.onTap = onTap
  }
  
  // MARK: - Color
  private var borderColor: Color {
    switch style {
    case .dim:
      return isOn ? .bl4 : .textw
    case .clear:
      return isOn ? .bl4 : .n50
    }
  }
  
  private var fillColor: Color {
    switch style {
    case .dim:
      return isOn ? .bl6 : .dim
    case .clear:
      return isOn ? .bl6 : .clear
    }
  }
  
  private var checkmarkColor: Color {
    isOn ? .textw : .clear
  }
}

// MARK: - Body
public extension CheckboxButton {
  var body: some View {
    Button {
      withAnimation(.easeInOut(duration: 0.2)) {
        isOn.toggle()
      }
      onTap?()
    } label: {
      ZStack {
        Circle()
          .fill(fillColor)
          .overlay(
            Circle()
              .stroke(borderColor, lineWidth: 1.5)
          )
        Image(icon: Icon.check)
          .renderingMode(.template)
          .resizable()
          .scaledToFit()
          .frame(width: 12, height: 12)
          .foregroundStyle(checkmarkColor)
      }
      .contentShape(Circle())
    }
    .frame(width: 24, height: 24)
    .buttonStyle(.plain)
  }
}

// MARK: - Preview
private struct CheckboxButtonPreview: View {
  @State private var isOn = false
  
  var body: some View {
    ZStack {
      Color.gray
        .ignoresSafeArea()
      VStack {
        CheckboxButton(isOn: $isOn, style: .dim)
        CheckboxButton(isOn: $isOn, style: .clear)
      }
    }
  }
}

#Preview {
  CheckboxButtonPreview()
}
