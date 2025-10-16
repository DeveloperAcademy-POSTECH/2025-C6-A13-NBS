//
//  Button.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
//

import SwiftUI
/// `Button`
///
/// Button 커스텀 네비게이션 바 컴포넌트입니다.
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
struct TopAppBarButton {
  @State private var isEditing = false
  let backgroundColor: UIColor = DesignSystemAsset.background.color
  let backButtonColor: UIColor = DesignSystemAsset.icon.color
}

extension TopAppBarButton: View {
  var body: some View {
      HStack {
        Image(icon: Icon.chevronLeft)
          .resizable()
          .frame(width: 24, height: 24)
          .frame(width: 44, height: 44)
          .contentShape(Rectangle())
          .padding(.leading, 4)
        Spacer()
        ChipButton(
          title: isEditing ? ChipTitle.done : ChipTitle.edit,
          style: .deep,
          isOn: .constant(true)
        )
        .padding(.trailing, 20)
      }
      .frame(height: 60)
      .background(DesignSystemAsset.background.swiftUIColor)
    }
}

#Preview {
  TopAppBarButton()
}
