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
    VStack(spacing: 0) {
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
      .padding(.bottom, 10)
      MainButton(
        "수정하기",
        isDisabled: store.selectedCategory == nil,
        hasGradient: true
      ) {
        store.send(.editButtonTapped)
      }
    }
    .background(DesignSystemAsset.background.swiftUIColor)
    .toolbar(.hidden)
    .task {
      NotificationCenter.default.addObserver(
        forName: .categoryEdited,
        object: nil,
        queue: .main
      ) { _ in
        store.send(.showToast("카테고리를 수정했어요"))
      }
    }
    .overlay(alignment: .bottom) {
      if store.showToast {
        AlertIconBanner(
          icon: Image(icon: Icon.badgeCheck),
          title: store.toastMessage,
          iconColor: .badgeColor
        )
        .zIndex(1)
        .padding(.horizontal, 20)
        .padding(.bottom, 92)
      }
    }
    .animation(.easeInOut(duration: 0.3), value: store.showToast)
    .onAppear {
      store.send(.onAppear)
    }
  }
}

#Preview {
  EditCategoryView(store: Store(initialState: EditCategoryFeature.State()) {
    EditCategoryFeature()
  })
}
