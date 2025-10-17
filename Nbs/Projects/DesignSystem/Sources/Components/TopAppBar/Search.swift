//
//  Search.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
//

import SwiftUI
/// `TopAppBarSearch`
///
/// Search 커스텀 네비게이션 바 컴포넌트입니다.
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
public struct TopAppBarSearch {
  @Binding var text: String
  let backgroundColor: UIColor = DesignSystemAsset.background.color
  let backButtonColor: UIColor = DesignSystemAsset.bl1.color
  let searchButton: UIColor = DesignSystemAsset.background.color
}

extension TopAppBarSearch: View {
  public var body: some View {
    HStack(spacing: 0) {
      Image(icon: Icon.chevronLeft)
        .resizable()
        .frame(width: 24, height: 24)
        .frame(width: 44, height: 44)
        .contentShape(Rectangle())
        .padding(.leading, 4)
      
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color(.systemGray6))
        
        TextField("검색어를 입력해 주세요", text: $text)
          .foregroundColor(text.isEmpty ? .caption2 : .text1)
          .padding(.horizontal, 12)
          .overlay(
            HStack {
              Spacer()
              if !text.isEmpty {
                Button {
                  text = ""
                } label: {
                  Image(icon: Icon.smallxCircleFilled)
                    .foregroundColor(.n80)
                }
                .padding(.trailing, 8)
              }
            }
          )
      }
      .frame(height: 40)
      .frame(maxWidth: .infinity)
      .padding(.trailing, 20)
    }
    .frame(height: 60)
    .background(DesignSystemAsset.background.swiftUIColor)
  }
}

#Preview {
  TopAppBarSearch(text: .constant("sdposdfp"))
}
