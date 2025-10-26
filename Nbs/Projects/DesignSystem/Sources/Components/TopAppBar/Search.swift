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
/// - TCA 호환: `viewStore.binding(\.$searchText)` 형태로 사용 가능.
/// - 예시:
/// ```swift
/// WithViewStore(store, observe: \.searchText) { viewStore in
///   TopAppBarSearch(
///     text: viewStore.binding(\.$searchText),
///     onBack: { viewStore.send(.backTapped) }
///   )
/// }
/// ```
public struct TopAppBarSearch {
  @Binding public var text: String
  
  var isFocused: FocusState<Bool>.Binding

  private let onBack: (() -> Void)?
  private let onSubmit: (() -> Void)?
  private let onClear: (() -> Void)?

  public let backgroundColor: UIColor = DesignSystemAsset.background.color
  public let backButtonColor: UIColor = DesignSystemAsset.bl1.color
  public let searchButton: UIColor = DesignSystemAsset.background.color

  public init(
    text: Binding<String>,
    isFocused: FocusState<Bool>.Binding,
    onBack: (() -> Void)? = nil,
    onSubmit: (() -> Void)? = nil,
    onClear: (() -> Void)? = nil
  ) {
    self._text = text
    self.isFocused = isFocused
    self.onBack = onBack
    self.onSubmit = onSubmit
    self.onClear = onClear
  }
}

extension TopAppBarSearch: View {
  public var body: some View {
    HStack(spacing: 0) {
      Button(action: { onBack?() }) {
        Image(icon: Icon.chevronLeft)
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(.icon)
          .frame(width: 24, height: 24)
          .frame(width: 44, height: 44)
          .contentShape(Rectangle())
          .padding(.leading, 4)
      }

      HStack(spacing: 0) {
        TextField(
          "검색어를 입력해주세요",
          text: $text,
          onCommit: { onSubmit?() }
        )
        .focused(isFocused)
        .font(.B1_M)
        .foregroundColor(.text1)
        
        if !text.isEmpty {
          Button {
            text = ""
            onClear?()
          } label: {
            Image(icon: Icon.smallxCircleFilled)
              .foregroundColor(.n80)
          }
          .padding(.trailing, 8)
        }
      }
      .padding(.leading, 8)
      .frame(height: 40)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(Color(.systemGray6))
      )
      .frame(maxWidth: .infinity)
      .padding(.trailing, 20)
    }
    .frame(height: 60)
    .background(DesignSystemAsset.background.swiftUIColor)
  }
}

//#Preview {
//  TopAppBarSearch(
//    text: .constant("예시 검색어"),
//    onBack: { print("뒤로가기") },
//    onSubmit: { print("검색 실행") },
//    onClear: { print("입력 초기화") }
//  )
//}
