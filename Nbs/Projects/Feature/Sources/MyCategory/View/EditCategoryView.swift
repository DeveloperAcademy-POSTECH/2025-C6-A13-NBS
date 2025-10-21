//
//  EditCategoryView.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct EditCategoryView {
  let store: StoreOf<EditCategoryFeature>
}

extension EditCategoryView: View {
  var body: some View {
    VStack {
      TopAppBarTitleOnly(title: store.naviTitle)
      CategoryGridView(
        store: store.scope(
          state: \.categoryGrid,
          action: \.categoryGrid
        )
      )
      HStack {
        MainButton(
          "취소",
          style: .soft
        ) {
          store.send(.cancelButtonTapped)
        }
        MainButton(
          "수정하기",
          isDisabled: store.selectedCategory == nil
        ) {
          store.send(.editButtonTapped)
        }
      }
      .padding(.horizontal, 20)
    }
    .background(DesignSystemAsset.background.swiftUIColor)
    .toolbar(.hidden)
  }
}

#Preview {
  EditCategoryView(store: Store(initialState: EditCategoryFeature.State()) {
    EditCategoryFeature()
  })
}
