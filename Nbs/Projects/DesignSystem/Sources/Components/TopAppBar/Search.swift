//
//  Search.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
//

import SwiftUI
/// `TopAppBarSearch`
///
/// Default 커스텀 네비게이션 바 컴포넌트입니다.
///
/// 사용 예시:
/// ```swift
/// VStack(spacing: 0) {
///    NavigationStack {
///     TopAppBarSearch()
///   }
///     .navigationBarHidden(true)
///     기본 네비게이션 버튼을 가려줘야 합니다.!~!
/// }
/// ```
struct TopAppBarSearch {
  @Binding var text: String
  let backgroundColor: UIColor = DesignSystemAsset.background.color
  let backButtonColor: UIColor = DesignSystemAsset.bl1.color
  let searchButton: UIColor = DesignSystemAsset.background.color
}

extension TopAppBarSearch: View {
  var body: some View {
    HStack {
      Image(icon: Icon.chevronLeft)
        .resizable()
        .frame(width: 24, height: 24)
        .frame(width: 44, height: 44)
        .contentShape(Rectangle())
        .padding(.leading, 4)
      Spacer()
      HStack(spacing: 0) {
        TextField("검색어를 입력해 주세요", text: $text)
          .textFieldStyle(.plain)
      }
      .padding(.trailing, 24)
    }
    .frame(height: 56)
    .background(DesignSystemAsset.background.swiftUIColor)
  }
}

#Preview {
  TopAppBarSearch(text: .constant("타이틀"))
}
