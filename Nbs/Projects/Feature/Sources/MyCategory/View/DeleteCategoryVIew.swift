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
      HStack {
        MainButton(
          "취소",
          style: .soft
        ) {
          store.send(.cancelButtonTapped)
        }
        MainButton(
          "삭제하기",
          isDisabled: store.selectedCategories.isEmpty
        ) {
          store.send(.deleteButtonTapped)
        }
      }
      .padding(.horizontal, 20)
    }
    .background(DesignSystemAsset.background.swiftUIColor)
    .toolbar(.hidden)
  }
}
