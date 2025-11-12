//
//  InfoListItem.swift
//  DesignSystem
//
//  Created by 이안 on 11/5/25.
//

import SwiftUI

/// 설정 뷰에서 쓰이는 정보 리스트 아이템
public struct InfoListItem: View {
  
  // MARK: - Trailing Type
  public enum TrailingType {
    case chevron
    case text(() -> String)
    case none
  }
  
  // MARK: - Properties
  private let icon: String
  private let title: String
  private let trailing: TrailingType
  private let action: (() -> Void)?
  
  // MARK: - Init
  public init(
    icon: String,
    title: String,
    trailing: TrailingType = .chevron,
    action: (() -> Void)? = nil
  ) {
    self.icon = icon
    self.title = title
    self.trailing = trailing
    self.action = action
  }
}

// MARK: - View
extension InfoListItem {
  public var body: some View {
    Button {
      action?()
    } label: {
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
          .lineLimit(1)
          .layoutPriority(1) 
        
        Spacer()
        
        trailingContents
      }
      .frame(maxWidth: .infinity)
      .frame(height: 52)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
  
  @ViewBuilder
  private var trailingContents: some View {
    switch trailing {
    case .chevron:
      Image(icon: Icon.chevronRight)
        .resizable()
        .renderingMode(.template)
        .scaledToFit()
        .frame(width: 24, height: 24)
        .foregroundStyle(.iconGray)
        .frame(maxWidth: .infinity, alignment: .trailing)
      
    case .text(let value):
      Text(value())
        .font(.B1_M)
        .foregroundStyle(.caption1)
        .padding(.trailing, 8)
      
    case .none:
      EmptyView()
    }
  }
}

#Preview {
  VStack(spacing: .zero) {
    InfoListItem(icon: Icon.info, title: "앱 버전", trailing: .text { "1.0.0" } )
    InfoListItem(icon: Icon.shield, title: "개인정보 처리방침")
  }
  .padding()
}
