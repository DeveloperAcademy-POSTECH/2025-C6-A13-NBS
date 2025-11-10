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
        onTapSettingButton: { store.send(.settingButtonTapped) }
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
          .scrollIndicators(.hidden)
          
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
    .toolbar(.hidden)
    .task {
      NotificationCenter.default.addObserver(
        forName: .linkSaved,
        object: nil,
        queue: .main
      ) { _ in
        store.send(.showToast(""))
      }
    }
    .overlay(alignment: .bottom) {
      if store.showToast {
        AlertBanner(
          text: "링크를 저장했어요!",
          message: "정책에서 확인할 수 있어요",
          style: .common
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
      }
    }
    .animation(.easeInOut(duration: 0.3), value: store.showToast)
  }
}
