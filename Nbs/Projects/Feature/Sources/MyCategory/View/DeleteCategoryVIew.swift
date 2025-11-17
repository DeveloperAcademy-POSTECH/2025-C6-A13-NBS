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
    VStack(spacing: 15) {
      TopAppBarDefaultRightIconxFeatureView(
        store: store.scope(
          state: \.topAppBar,
          action: \.topAppBar
        )
      )
      CategoryGridView(
        store: store.scope(
          state: \.categoryGrid,
          action: \.categoryGrid
        )
      )
      MainButton(
        "(\(store.selectedCategories.count)) 삭제하기",
        style: .danger,
        isDisabled: store.selectedCategories.isEmpty
      ) {
        store.send(.deleteButtonTapped)
      }
    }
    .background(DesignSystemAsset.background.swiftUIColor)
    .toolbar(.hidden)
    .overlay {
      if store.isAlert {
        ZStack {
          Color.dim.ignoresSafeArea()
          AlertDialog(
            title: "\(store.selectedCategories.count)개의 카테고리를 삭제할까요?",
            subtitle: "포함된 링크는 전체 카테고리로 이동돼요",
            cancelTitle: "취소",
            onCancel: { store.send(.confirmAlertDismissed) },
            buttonType: .delete(title: "삭제", action: {
              store.send(.confirmAlertConfirmButtonTapped)
            })
          )
        }
      }
    }
  }
}
