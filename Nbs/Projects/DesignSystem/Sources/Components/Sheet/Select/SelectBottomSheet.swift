//
//  SelectBottomSheet.swift
//  DesignSystem
//
//  Created by 이안 on 10/15/25.
//

import SwiftUI

// MARK: - Model
public struct CategoryProps: Identifiable, Equatable {
  public let id: UUID
  public let title: String
  
  public init(id: UUID, title: String) {
    self.id = id
    self.title = title
  }
}

// MARK: - Properties
public struct SelectBottomSheet: View {
  let sheetTitle: String
  let items: [CategoryProps]
  let categoryButtonTapped: (String) -> Void
  let selectButtonTapped: () -> Void
  let dismissButtonTapped: () -> Void
  let selectedCategory: String?
  let buttonTitle: String
  
  public init(
    sheetTitle: String,
    items: [CategoryProps],
    categoryButtonTapped: @escaping (String) -> Void,
    selectButtonTapped: @escaping () -> Void,
    dismissButtonTapped: @escaping () -> Void,
    selectedCategory: String?,
    buttonTitle: String = "선택하기"
  ) {
    self.sheetTitle = sheetTitle
    self.items = items
    self.categoryButtonTapped = categoryButtonTapped
    self.selectButtonTapped = selectButtonTapped
    self.dismissButtonTapped = dismissButtonTapped
    self.selectedCategory = selectedCategory
    self.buttonTitle = buttonTitle
  }
}

// MARK: - View
extension SelectBottomSheet {
  public var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      VStack {
        HStack(alignment: .center, spacing: 8) {
          Text(sheetTitle)
            .font(.B1_SB)
            .lineLimit(1)
            .foregroundStyle(.text1)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.leading, 48)
          Button {
            dismissButtonTapped() // 닫기 버튼 액션 연결
          } label: {
            Image(icon: Icon.x)
              .frame(width: 24, height: 24)
              .padding(.trailing, 20)
          }
        }
        .padding(.vertical, 20)
        
        ScrollView(.vertical, showsIndicators: false) {
          LazyVStack {
            ForEach(items) { item in
              SelectBottomSheetItem(
                title: item.title,
                isSelected: item.title == selectedCategory,
                action: { categoryButtonTapped(item.title) }
              )
            }
          }
        }
        .padding(.horizontal, 20)
        
        MainButton(
          buttonTitle,
          hasGradient: true,
          action: { selectButtonTapped() }
        )
      }
      .padding(.top, 8)
    }
  }
}

#Preview {
  SelectBottomSheet(
    sheetTitle: "카테고리 필터",
    items: [
      .init(id: UUID(), title: "1"),
      .init(id: UUID(), title: "2"),
      .init(id: UUID(), title: "3"),
    ],
    categoryButtonTapped: { _ in },
    selectButtonTapped: {},
    dismissButtonTapped: {},
    selectedCategory: "2",
    buttonTitle: "이동하기"
  )
}
