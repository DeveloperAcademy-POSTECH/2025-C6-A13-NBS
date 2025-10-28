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
import LinkNavigator

struct HomeView {
  let navigator: SingleLinkNavigator
  
  @Bindable var store: StoreOf<HomeFeature>
  @Environment(\.scenePhase) private var scenePhase
}

extension HomeView: View {
  var body: some View {
    VStack {
      TopAppBarHome(
        onTapSearchButton: { store.send(.searchButtonTapped) } ,
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
          .refreshable {
            store.send(.refresh)
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
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase == .active {
        store.send(.onAppear)
      }
    }
    .background(Color.background)
    .navigationBarHidden(true)
  }
}
