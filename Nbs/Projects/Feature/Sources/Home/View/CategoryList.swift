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
      HStack(spacing: 0) {
        Text(ArticleNameSpace.showCategory)
          .font(.B1_SB)
          .foregroundStyle(.caption1)
        Spacer()
        Button {
          store.send(.moreCategoryButtonTapped)
        } label: {
          HStack {
            Text(ArticleNameSpace.showMore)
              .font(.B2_M)
              .foregroundStyle(.caption1)
            Image(icon: Icon.smallChevronRight)
              .resizable()
              .frame(width: 20, height: 20)
          }
        }
      }
      .padding(.horizontal, 20)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 8) {
          ForEach(store.state.categories) { category in
            Button {
              store.send(.categoryTapped(category))
            } label: {
              Text(category.name)
                .font(.B2_M)
                .foregroundStyle(store.state.selectedCategory == category ? .white : .gray)
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
          }
        }
        .padding(.horizontal, 20)
      }
    }
  }
}

#Preview {
  CategoryListView(
    store: Store(
      initialState: CategoryListFeature.State()) {
        CategoryListFeature()
      }
    )
}
