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
    VStack(spacing: 8) {
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
          HStack(spacing: 10) {
            ForEach(store.categories.reversed()) { category in
              CategoryChipButton(
                title: category.categoryName,
                categoryType: category.icon.number
              ) {
                store.send(.categoryTapped(category))
              }
            }
          }
          .padding(.horizontal, 20)
        }
        .scrollDisabled(store.categories.count < 2)
        .scrollIndicators(.hidden)
      }
    }
    .onAppear { store.send(.onAppear) }
  }
}
