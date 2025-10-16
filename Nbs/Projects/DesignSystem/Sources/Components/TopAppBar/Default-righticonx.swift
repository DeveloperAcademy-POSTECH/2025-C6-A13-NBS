//
//  Default-righticonx.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
//

import SwiftUI
/// `TopAppBarDefaultRightIconx`
///
/// DefaultRightIconx 커스텀 네비게이션 바 컴포넌트입니다.
///
/// 사용 예시:
/// ```swift
/// VStack(spacing: 0) {
///    NavigationStack {
///     TopAppBarDefaultRightIconx()
///   }
///     .navigationBarHidden(true)
///     기본 네비게이션 버튼을 가려줘야 합니다.!~!
/// }
/// ```
struct TopAppBarDefaultRightIconx {
  let title: String
  let backgroundColor: UIColor = DesignSystemAsset.background.color
  let backButtonColor: UIColor = DesignSystemAsset.icon.color
  
  init(title: String) { self.title = title }
}

extension TopAppBarDefaultRightIconx: View {
  var body: some View {
    ZStack {
      HStack {
        Image(icon: Icon.chevronLeft)
          .resizable()
          .frame(width: 24, height: 24)
          .frame(width: 44, height: 44)
          .contentShape(Rectangle())
          .padding(.leading, 4)
        Spacer()
      }
      .padding(.trailing, 24)
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
  TopAppBarDefaultRightIconx(title: "타이틀")
}
