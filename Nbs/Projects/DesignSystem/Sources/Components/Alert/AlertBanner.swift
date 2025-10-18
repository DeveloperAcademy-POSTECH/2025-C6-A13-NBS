//
//  AlertBanner.swift
//  DesignSystem
//
//  Created by 이안 on 10/16/25.
//

import SwiftUI

/// 상단 알림 배너 컴포넌트
///
/// 앱 상단에 표시되는 간단한 알림용 배너
/// 상황에 따라 `닫기(X)`, `액션 버튼`, 또는 일반형(`common`) 스타일로 사용
///
/// - Parameters:
///   - text: 배너의 메인 텍스트
///   - message: 부제목 또는 보조 설명 (선택)
///   - style: 표시 형태 (`.close`, `.action`, `.common`)
public struct AlertBanner: View {
  
  // MARK: - Style
  public enum Style {
    case close(action: (() -> Void)? = nil) // X 버튼
    case action(title: String)              // 오른쪽 버튼
    case common                             // 텍스트만
  }
  
  // MARK: - Properties
  let text: String
  let message: String?
  let style: Style
  
  // MARK: - Init
  public init(
    text: String,
    message: String? = nil,
    style: Style
  ) {
    self.text = text
    self.message = message
    self.style = style
  }
}

// MARK: - Body
public extension AlertBanner {
  var body: some View {
    HStack(spacing: 0) {
      textContents
      Spacer()
      buttonContents
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 18)
    .background(.alert)
    .cornerRadius(12)
  }
  
  /// 텍스트 모음
  private var textContents: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(text)
        .font(.B1_M)
        .foregroundStyle(.textw)
      if let message {
        Text(message)
          .font(.C2)
          .foregroundStyle(.caption3)
      }
    }
  }
  
  /// 버튼 모음
  private var buttonContents: some View {
    Group {
      switch style {
      case let .close(action):
        Button {
          action?()
        } label: {
          Color.clear.frame(width: 40, height: 40)
          Image(icon: Icon.x)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundStyle(.textw)
        }
        .buttonStyle(.plain)
      case let .action(title):
        ChipButton(title: title, style: .deep, isOn: .constant(true))
          .fixedSize()
        
      case .common:
        EmptyView()
      }
    }
  }
}

// MARK: - Preview
#Preview {
  VStack(spacing: 16) {
    AlertBanner(
      text: "텍스트",
      message: "서브 텍스트",
      style: .close { print("") }
    )
    AlertBanner(
      text: "텍스트",
      message: "서브 텍스트",
      style: .action(title: "텍스트")
    )
    AlertBanner(
      text: "텍스트",
      message: "서브 텍스트",
      style: .common
    )
  }
  .padding()
}
