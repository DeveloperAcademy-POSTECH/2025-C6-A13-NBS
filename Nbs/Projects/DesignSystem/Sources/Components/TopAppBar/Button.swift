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
public struct TopAppBarButton {
  public var isEditing: Bool
  public var onTapChipButton: () -> Void
  public var onTapBackButton: () -> Void
  
  public init(
    isEditing: Bool,
    onTapChipButton: @escaping () -> Void,
    onTapBackButton: @escaping () -> Void
  ) {
    self.isEditing = isEditing
    self.onTapChipButton = onTapChipButton
    self.onTapBackButton = onTapBackButton
  }
}

extension TopAppBarButton: View {
 public var body: some View {
      HStack {
        Button(action: onTapBackButton) {
          Image(icon: Icon.chevronLeft)
            .resizable()
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
            .foregroundStyle(Color.icon)
            .padding(.leading, 4)
        }
        Spacer()
        
        Button(action: onTapChipButton) {
          ChipButton(
            title: isEditing ? ChipTitle.done : ChipTitle.edit,
            style: .deep,
            isOn: .constant(true)
          )
          .padding(.trailing, 20)
        }
      }
      .frame(height: 60)
      .background(DesignSystemAsset.background.swiftUIColor)
    }
}

#Preview {
  TopAppBarButton(isEditing: true) {
    
  } onTapBackButton: {
    
  }
}
