//
//  Default.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
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
struct TopAppBarDefault {
  let title: String
  let backgroundColor: UIColor = DesignSystemAsset.background.color
  let backButtonColor: UIColor = DesignSystemAsset.bl1.color
  let searchButton: UIColor = DesignSystemAsset.background.color
  
  init(title: String) { self.title = title }
}

extension TopAppBarDefault: View {
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
        HStack(spacing: 0) {
          Button {
            print("검색 탭 클릭")
          } label: {
            Image(icon: Icon.search)
              .resizable()
              .frame(width: 24, height: 24)
              .frame(width: 44, height: 44)
              .contentShape(Rectangle())
          }
          Button {
            print("설정 탭 클릭")
          } label: {
            Image(icon: Icon.moreVertical)
              .resizable()
              .frame(width: 24, height: 24)
              .frame(width: 44, height: 44)
              .contentShape(Rectangle())
          }
        }
        .padding(.trailing, 24)
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
  TopAppBarDefault(title: "타이틀")
}
