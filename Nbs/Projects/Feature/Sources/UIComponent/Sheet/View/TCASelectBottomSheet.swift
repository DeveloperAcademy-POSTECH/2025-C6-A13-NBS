//
//  TCASelectBottomSheet.swift
//  Feature
//
//  Created by 여성일 on 10/22/25.
//

import SwiftUI

import DesignSystem
import ComposableArchitecture

// MARK: - Properties
struct TCASelectBottomSheet: View {
  let title: String
  let store: StoreOf<SelectBottomSheetFeature>
}

// MARK: - View
extension TCASelectBottomSheet {
  var body: some View {
    SelectBottomSheet(
      sheetTitle: title,
      items: store.categories.elements,
      categoryButtonTapped: { category in store.send(.categoryTapped(category)) },
      selectButtonTapped: { store.send(.selectButtonTapped) },
      dismissButtonTapped: { store.send(.closeTapped) }, selectedCategory: store.selectedCategory
    )
    .onAppear {
      
    }
  }
}

#Preview {
  TCASelectBottomSheet(
    title: "카테고리 선택",
    store: Store(
      initialState: SelectBottomSheetFeature.State(),
      reducer: { SelectBottomSheetFeature() }
    )
  )
}
