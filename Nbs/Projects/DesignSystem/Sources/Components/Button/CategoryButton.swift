//
//  CategoryButton.swift
//  DesignSystem
//
//  Created by 여성일 on 10/18/25.
//

import SwiftUI

/// ShareExtension에서 사용되는 카테고리 버튼
///
/// 토글 가능한 버튼으로, 선택 여부(`isOn`)에 따라 색상과 Stroke 변경, 긴 카테고리명(띄어쓰기 포함 6자 넘어가는 경우)은 줄임표를 사용하여 title을 표기합니다.
///
/// - Parameters:
///   - isOn: 현재 선택 상태 (Binding)
///   - onTap: 선택 상태 변경 후 실행할 클로저 (선택)
///   - title: 카테고리 이름
///   - icon: 카테고리 아이콘
///
// MARK: - Properties
public struct CategoryButton: View {
  public enum ButtonType {
    case normal
    case nontitle
  }
  
  let type: ButtonType
  let title: String?
  let icon: String

  @Binding var isOn: Bool
  
  var onTap: (() -> Void)?
  
  public init(
    type: ButtonType = .normal,
    title: String? = nil,
    icon: String,
    isOn: Binding<Bool>,
    onTap: (() -> Void)? = nil
  ) {
    self.type = type
    self.title = title
    self.icon = icon
    self._isOn = isOn
    self.onTap = onTap
  }
  
  private var backgroundColor: Color {
    isOn ? .bl1 : .n30
  }
  
  private var strokeColor: Color {
    isOn ? .bl6 : .clear
  }
}

// MARK: - View
public extension CategoryButton {
  var body: some View {
    VStack(spacing: 8) {
      Button {
        withAnimation(.easeInOut(duration: 0.2)) {
          isOn.toggle()
        }
        onTap?()
      } label: {
        ZStack {
          Image(icon: icon)
            .frame(width: 45, height: 45)
        }
        .frame(width: 80, height: 80)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
          RoundedRectangle(cornerRadius: 12)
            .stroke(strokeColor, lineWidth: 1.04)
        }
      }
      .buttonStyle(.plain)
      
      if type == .normal, let title = title {
        Text(title)
          .font(.B2_SB)
          .foregroundStyle(.text1)
          .lineLimit(1)
      }
    }
    .frame(maxWidth: 80)
  }
}

// MARK: - Preview
private struct CategoryButtonPreview: View {
  @State private var isOn = false
  
  var body: some View {
    ZStack {
      Color.gray
        .ignoresSafeArea()
      
      VStack(spacing: 16) {
        HStack(spacing: 16) {
          CategoryButton(title: "비활성화상태", icon: "plus", isOn: .constant(false))
          CategoryButton(title: "활성화상태", icon: "plus", isOn: .constant(true))
          CategoryButton(title: "긴 카테고리입니다. 띄어쓰기 포함 6자를 넘어가는 경우 테스트", icon: "plus", isOn: .constant(true))
          CategoryButton(type:.nontitle, title: "긴 카테고리입니다. 띄어쓰기 포함 6자를 넘어가는 경우 테스트", icon: "plus", isOn: .constant(true))
        }
        CategoryButton(title: "토글확인", icon: "plus", isOn: $isOn, onTap: {})
      }
    }
  }
}

#Preview {
  CategoryButtonPreview()
}
