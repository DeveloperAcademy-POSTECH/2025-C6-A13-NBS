//
//  DeleteCategoryVIew.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct DeleteCategoryView {
  let store: StoreOf<DeleteCategoryFeature>
}

extension DeleteCategoryView: View {
  var body: some View {
    VStack {
      TopAppBarTitleOnly(title: store.naviTitle)
      CategoryGridView(
        store: store.scope(
          state: \.categoryGrid,
          action: \.categoryGrid
        )
      )
      MainButton(
        "삭제하기",
        style: .danger,
        isDisabled: store.selectedCategories.isEmpty
      ) {
        store.send(.deleteButtonTapped)
      }
    }
    .background(DesignSystemAsset.background.swiftUIColor)
    .toolbar(.hidden)
  }
}
