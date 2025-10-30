//
//  DefaultDetail.swift
//  DesignSystem
//
//  Created by 이안 on 10/23/25.
//

import SwiftUI
/// `TopAppBarDefault`
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
public struct TopAppBarDefaultDetail {
  public let title: String
  public let onTapBackButton: () -> Void
  public let onTapSearchButton: () -> Void
  public let onTapSettingButton: () -> Void
  
  public init(
    title: String,
    onTapBackButton: @escaping () -> Void,
    onTapSearchButton: @escaping () -> Void,
    onTapSettingButton: @escaping () -> Void
  ) {
    self.title = title
    self.onTapBackButton = onTapBackButton
    self.onTapSearchButton = onTapSearchButton
    self.onTapSettingButton = onTapSettingButton
  }
}

extension TopAppBarDefaultDetail: View {
  public var body: some View {
    ZStack {
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
        HStack(spacing: 0) {
          Button(action: onTapSearchButton) {
            Image(icon: Icon.share)
              .resizable()
              .renderingMode(.template)
              .foregroundStyle(.icon)
              .frame(width: 24, height: 24)
              .frame(width: 44, height: 44)
              .contentShape(Rectangle())
          }
          Button(action: onTapSettingButton) {
            Image(icon: Icon.trash)
              .resizable()
              .renderingMode(.template)
              .foregroundStyle(.icon)
              .frame(width: 24, height: 24)
              .frame(width: 44, height: 44)
              .contentShape(Rectangle())
          }
        }
        .padding(.trailing, 10)
      }
      Text(title)
        .font(.H4_SB)
        .lineLimit(1)
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .foregroundStyle(.text1)
    }
    .frame(height: 60)
    .background(DesignSystemAsset.background.swiftUIColor)
  }
}

#Preview {
  TopAppBarDefaultDetail(
    title: "타이틀",
    onTapBackButton: {},
    onTapSearchButton: {},
    onTapSettingButton: {}
  )
}
