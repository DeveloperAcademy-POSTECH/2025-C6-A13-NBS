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
  @Environment(\.scenePhase) private var scenePhase
}

extension HomeView: View {
  var body: some View {
    NavigationStack {
//      TopAppBarHome()
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
          
          AddFloatingButton()
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
            print("Toast 알림")
          }
        }
      }
      .background(DesignSystemAsset.background.swiftUIColor.ignoresSafeArea())
      .navigationBarHidden(true)
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
