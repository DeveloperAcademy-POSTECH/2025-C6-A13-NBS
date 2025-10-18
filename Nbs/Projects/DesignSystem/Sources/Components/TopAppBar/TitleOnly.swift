//
//  TitleOnly.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
//

import SwiftUI
/// `TitleOnly`
///
/// TitleOnly 커스텀 네비게이션 바 컴포넌트입니다.
///
/// 사용 예시:
/// ```swift
/// VStack(spacing: 0) {
///    NavigationStack {
///     TopAppBarTitleOnly()
///   }
///     .navigationBarHidden(true)
///     기본 네비게이션 버튼을 가려줘야 합니다.!~!
/// }
/// ```
public struct TopAppBarTitleOnly {
  let title: String
  let backgroundColor: UIColor = DesignSystemAsset.background.color
  
  public init(title: String) { self.title = title }
}

extension TopAppBarTitleOnly: View {
  public var body: some View {
      HStack {
        Text(title)
          .font(.H4_SB)
          .lineLimit(1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .foregroundStyle(.text1)
          .padding(.leading, 20)
        Spacer()
      }
      .frame(height: 60)
      .background(DesignSystemAsset.background.swiftUIColor)
    }
}

#Preview {
  TopAppBarTitleOnly(title: "타이틀")
}
