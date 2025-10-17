//
//  HomeView.swift
//  Feature
//
//  Created by 홍 on 10/15/25.
//

import SwiftUI

import ComposableArchitecture
import Domain
import DesignSystem

struct HomeView {
  let store: StoreOf<HomeFeature>
}

extension HomeView: View {
  var body: some View {
    NavigationStack {
      TopAppBarHome()
      ScrollView {
        VStack(spacing: 24) {
          CategoryListView(
            store: store.scope(
              state: \.categoryList,
              action: \.categoryList
            )
          )
          
          ArticleListView(
            store: store.scope(
              state: \.articleList,
              action: \.articleList
            )
          )
        }
      }
      .navigationBarHidden(true)
    }
  }
}

#Preview {
  HomeView(store: Store(initialState: HomeFeature.State()) {
    HomeFeature()
  })
}
