//
//  Home.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
//

import SwiftUI

/// `TopAppBarHome`
///
/// 홈 화면 상단에 표시되는 커스텀 네비게이션 바 컴포넌트입니다.
/// 왼쪽에는 앱 로고(또는 타이틀), 오른쪽에는 검색 및 설정 버튼이 배치되어 있습니다.
///
/// 사용 예시:
/// ```swift
/// VStack(spacing: 0) {
///    NavigationStack {
///     TopAppBarHome()
///   }
///     .navigationBarHidden(true)
///     기본 네비게이션 버튼을 가려줘야 합니다.!~!
/// }
/// ```
public struct TopAppBarHome {
  let title: String = "LOGO"
  public let onTapSearchButton: () -> Void
  public let onTapSettingButton: () -> Void
  
  public init(
    onTapSearchButton: @escaping () -> Void,
    onTapSettingButton: @escaping () -> Void
  ) {
    self.onTapSearchButton = onTapSearchButton
    self.onTapSettingButton = onTapSettingButton
  }
}

extension TopAppBarHome: View {
  public var body: some View {
    HStack {
      Text(title)
        .font(.B1_M)
        .foregroundStyle(.n700)
        .padding(.leading, 24)
      Spacer()
      HStack(spacing: 0) {
        Button(action: onTapSearchButton) {
          Image(icon: Icon.search)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.icon)
            .frame(width: 24, height: 24)
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
        }
        Button(action: onTapSettingButton) {
          Image(icon: Icon.settings)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.icon)
            .frame(width: 44, height: 44)
        }
      }
      .padding(.trailing, 8)
    }
    .frame(height: 60)
    .background(Color.background)
  }
}

#Preview {
  TopAppBarHome {
    
  } onTapSettingButton: {
    
  }
}
