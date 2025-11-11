//
//  SettingTipCard.swift
//  DesignSystem
//
//  Created by 이안 on 11/5/25.
//

import SwiftUI

/// 설정뷰에서 쓰이는 팁 카드 뷰
public struct SettingTipCard: View {
  
  // MARK: - Properties
  private let icon: Image
  private let title: String
  private let action: (() -> Void)?
  
  // MARK: - Init
  public init(
    icon: Image,
    title: String,
    action: (() -> Void)? = nil
  ) {
    self.icon = icon
    self.title = title
    self.action = action
  }
}

// MARK: - View
extension SettingTipCard {
  public var body: some View {
    Button {
      action?()
    } label: {
      VStack(alignment: .leading, spacing: 12) {
        topContents
        bottomContents
      }
      .padding(.horizontal, 8)
      .padding(.top, 8)
      .padding(.bottom, 20)
      .frame(height: 182, alignment: .top)
      .frame(minWidth: 161.5)
      .background(Color.n0)
      .cornerRadius(12)
      .shadow(
        color: Color.bgShadow3,
        radius: 4,
        x: 0, y: 0
      )
    }
    .buttonStyle(.plain)
  }
  
  /// 상단 컨텐츠
  private var topContents: some View {
    ZStack {
      Color.c13
      icon
        .resizable()
        .scaledToFit()
    }
    .frame(width: 145.5, height: 100)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
  
  /// 하단 컨텐츠
  private var bottomContents: some View {
    Text(title)
      .font(.B2_SB)
      .foregroundStyle(.text1)
      .multilineTextAlignment(.leading)
      .padding(.horizontal, 6)
  }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    SettingTipCard(
      icon: DesignSystemAsset.settingSafari.swiftUIImage,
      title: "Safari extension 허용하기"
    )
  }
}
