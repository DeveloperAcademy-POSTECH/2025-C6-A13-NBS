//
//  AlertIconBanner.swift
//  DesignSystem
//
//  Created by 이안 on 10/16/25.
//

import SwiftUI

/// 간단한 아이콘 알림 배너 컴포넌트
///
/// “즐겨찾기에 추가됨”, “저장 완료” 등과 같은
/// 짧은 피드백 메시지를 아이콘과 함께 표시
///
/// - Parameters:
///   - icon: 표시할 아이콘 이미지 (예: `Image(systemName:)`)
///   - title: 배너에 표시할 텍스트
///   - iconColor: 아이콘 색상
public struct AlertIconBanner: View {
  
  // MARK: - Properties
  let icon: Image
  let title: String
  let iconColor: Color
  
  // MARK: - Init
  public init(
    icon: Image,
    title: String,
    iconColor: Color
  ) {
    self.icon = icon
    self.title = title
    self.iconColor = iconColor
  }
}

// MARK: - Body
public extension AlertIconBanner {
  var body: some View {
    HStack(spacing: 8) {
      icon
        .resizable()
        .renderingMode(.template)
        .scaledToFit()
        .frame(width: 24, height: 24)
        .foregroundStyle(iconColor)
      
      Text(title)
        .font(.B1_M)
        .foregroundStyle(.textw)
      
      Spacer()
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 18)
    .frame(maxWidth: .infinity, minHeight: 60)
    .background(.alert)
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
  }
}

// MARK: - Preview
#Preview {
  AlertIconBanner(
    icon: Image(systemName: "exclamationmark.circle"),
    title: "경고 발생",
    iconColor: .red,
  )
}
