//
//  SelectBottomSheet.swift
//  DesignSystem
//
//  Created by 이안 on 10/15/25.
//

import SwiftUI

// MARK: - Model
public struct CategoryProps: Identifiable, Equatable {
  public let id: String
  public let title: String
  
  public init(id: String, title: String) {
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
  
  @State private var selectedItemID: String?

  public init(
    sheetTitle: String,
    items: [CategoryProps],
    categoryButtonTapped: @escaping (String) -> Void,
    selectButtonTapped: @escaping () -> Void,
    dismissButtonTapped: @escaping () -> Void
  ) {
    self.sheetTitle = sheetTitle
    self.items = items
    self.categoryButtonTapped = categoryButtonTapped
    self.selectButtonTapped = selectButtonTapped
    self.dismissButtonTapped = dismissButtonTapped
  }
}

// MARK: - View
extension SelectBottomSheet {
  public var body: some View {
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
            SelectBottomSheetItem(title: item.title, isSelected: selectedItemID == item.id, action: {
              self.selectedItemID = item.id
              categoryButtonTapped(item.id)
            })
          }
        }
      }
      .padding(.horizontal, 20)
      
      MainButton("선택하기", action: { selectButtonTapped() })
        .padding(.horizontal, 20)
    }
    .padding(.top, 8)
  }
}

#Preview {
  SelectBottomSheet(
    sheetTitle: "카테고리 필터",
    items: [
      .init(id: "1", title: "전체"),
      .init(id: "2", title: "정치"),
      .init(id: "3", title: "경제")
    ],
    categoryButtonTapped: { _ in },
    selectButtonTapped: {},
    dismissButtonTapped: {} 
  )
}
