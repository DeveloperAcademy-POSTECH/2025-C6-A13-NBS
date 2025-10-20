//
//  DefaultNoSearchIcon.swift
//  DesignSystem
//
//  Created by 홍 on 10/20/25.
//

import SwiftUI
/// `TopAppBarDefaultNoSearch`
///
/// Default 커스텀 네비게이션 바 컴포넌트입니다.
///
/// 사용 예시:
/// ```swift
/// VStack(spacing: 0) {
///    NavigationStack {
///     TopAppBarDefault()
///   }
///     .navigationBarHidden(true)
///     기본 네비게이션 버튼을 가려줘야 합니다.!~!
/// }
/// ```
public struct TopAppBarDefaultNoSearch {
  public let title: String
  public let onTapBackButton: () -> Void
  public let onTapSettingButton: () -> Void
  
  public init(
    title: String,
    onTapBackButton: @escaping () -> Void,
    onTapSettingButton: @escaping () -> Void
  ) {
    self.title = title
    self.onTapBackButton = onTapBackButton
    self.onTapSettingButton = onTapSettingButton
  }
}

extension TopAppBarDefaultNoSearch: View {
  public var body: some View {
      HStack {
        Button(action: onTapBackButton) {
          Image(icon: Icon.chevronLeft)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.icon)
            .frame(width: 24, height: 24)
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
            .padding(.leading, 4)
        }
        Spacer()
        Text(title)
          .font(.H4_SB)
          .lineLimit(1)
          .frame(maxWidth: .infinity)
          .multilineTextAlignment(.center)
          .foregroundStyle(.text1)
        Spacer()
        Button(action: onTapSettingButton) {
          Image(icon: Icon.moreVertical)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.icon)
            .frame(width: 24, height: 24)
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
        }
      }
    .frame(height: 60)
    .background(DesignSystemAsset.background.swiftUIColor)
  }
}

#Preview {
  TopAppBarDefaultNoSearch(
    title: "타이틀",
    onTapBackButton: {},
    onTapSettingButton: {}
  )
}
