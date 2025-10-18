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
      ZStack(alignment: .bottomTrailing) {
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
          .padding(.bottom, 80)
        }
        
        Button {
          
        } label: {
          Image(icon: Icon.plus)
            .foregroundStyle(DesignSystemAsset.bl6.swiftUIColor)
            .frame(width: 48, height: 48)
            .background(.n0)
            .clipShape(Circle())
        }
        .padding(.trailing, 20)
        .padding(.bottom, 24)
      }
      .background(DesignSystemAsset.background.swiftUIColor.ignoresSafeArea())
      .navigationBarHidden(true)
    }
  }
}

#Preview {
  HomeView(store: Store(initialState: HomeFeature.State()) {
    HomeFeature()
  })
}
