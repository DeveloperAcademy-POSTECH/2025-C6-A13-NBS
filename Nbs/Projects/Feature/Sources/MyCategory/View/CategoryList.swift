//
//  CategoryList.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct CategoryListView {
  let store: StoreOf<CategoryListFeature>
}

extension CategoryListView: View {
  var body: some View {
    VStack(spacing: 10) {
      ScrollViewHeader(
        headerTitle: .showCategory,
        buttonTitle: .showMore,
        showButton: !store.categories.isEmpty,
        onTap: {
          store.send(.moreCategoryButtonTapped)
        }
      )
        .padding(.horizontal, 20)
      
      if store.categories.isEmpty {
        MakeNewCategoryButton {
          store.send(.addCategoryButtonTapped)
        }
        .padding(.horizontal, 20)
      } else {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(store.categories.reversed()) { category in
              CategoryChipButton(
                title: category.categoryName,
                categoryType: category.icon.number
              ) {
                store.send(.categoryTapped(category))
              }
              .padding(.leading, 20)
            }
          }
        }
        .scrollDisabled(store.categories.count < 2)
      }
    }
    .onAppear { store.send(.onAppear) }
  }
}

#Preview {
  CategoryListView(store: Store(initialState: CategoryListFeature.State()) {
    CategoryListFeature()
  })
}
