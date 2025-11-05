//
//  InfoListItem.swift
//  DesignSystem
//
//  Created by 이안 on 11/5/25.
//

import SwiftUI

/// 설정 뷰에서 쓰이는 정보 리스트 아이템
public struct InfoListItem: View {
  
  // MARK: - Properties
  private let icon: String
  private let title: String
  private let action: (() -> Void)?
  
  // MARK: - Init
  public init(
    icon: String,
    title: String,
    action: (() -> Void)? = nil
  ) {
    self.icon = icon
    self.title = title
    self.action = action
  }
}

// MARK: - View
extension InfoListItem {
  public var body: some View {
    HStack(spacing: 8) {
      Image(icon: icon)
        .resizable()
        .renderingMode(.template)
        .scaledToFit()
        .foregroundStyle(.iconGray)
        .frame(width: 24, height: 24)
      
      Text(title)
        .font(.B1_M)
        .foregroundStyle(.text1)
        .multilineTextAlignment(.leading)
      
      Spacer()
      
      Button {
        action?()
      } label: {
        Image(icon: Icon.chevronRight)
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .frame(width: 24, height: 24)
          .foregroundStyle(.iconGray)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .frame(width: 44, height: 44)
      .buttonStyle(.plain)
    }
  }
}

#Preview {
  InfoListItem(icon: Icon.shield, title: "개인정보 처리방침") {
    print("하이")
  }
}
