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
  @Bindable var store: StoreOf<HomeFeature>
  @Environment(\.scenePhase) private var scenePhase
}

extension HomeView: View {
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack {
        TopAppBarHome(
          onTapSearchButton: { print ("")} ,
          onTapSettingButton: { print ("")}
        )
        ZStack(alignment: .bottom) {
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
            
            AddFloatingButton {
              store.send(.floatingButtonTapped)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 24)
          }
          
          if let alertBanner = store.state.alertBanner {
            AlertBanner(
              text: alertBanner.text,
              message: alertBanner.message,
              style: .close {
                store.send(.dismissAlertBanner)
              }
            )
            .padding(.horizontal, 20)
            .onTapGesture {
              store.send(.alertBannerTapped)
            }
          }
        }
      }
      .background(DesignSystemAsset.background.swiftUIColor.ignoresSafeArea())
      .navigationBarHidden(true)
    } destination: { store in
      switch store.case {
      case .linkList(let linkListStore):
        LinkListView(store: linkListStore)
      case .linkDetail(let store):
              LinkDetailView(store: store)
      case .categoryGridView(let store):
        CategoryGridView(store: store)
      case .addLink(let store):
        AddLinkView(store: store)
      case .addCategory(let store):
        AddCategoryView(store: store)
        
      }
    }
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase == .active {
        store.send(.onAppear)
      }
    }
  }
}

#Preview {
  HomeView(store: Store(initialState: HomeFeature.State()) {
    HomeFeature()
  })
}
