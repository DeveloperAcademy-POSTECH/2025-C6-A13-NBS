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
    ZStack {
      if store.isCheckingClipboard {
        ProgressView()
      } else {
        VStack(spacing: 0) {
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
              .padding(.bottom, 12)
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
              .padding(.bottom, 8)
              .onTapGesture {
                store.send(.alertBannerTapped)
              }
            }
          }
        }
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase == .active {
        store.send(.scenePhaseChangedToActive)
      }
    }
    .background(Color.background)
    .toolbar(.hidden)
    .task {
      NotificationCenter.default.addObserver(
        forName: .linkSaved,
        object: nil,
        queue: .main
      ) { notification in
        let category = notification.object as? CategoryItem
        let categoryName = category?.categoryName ?? "전체"
        let message = "\(categoryName)에 링크를 저장했어요!"
        store.send(.showToast(message))
      }
    }
    .task {
      NotificationCenter.default.addObserver(
        forName: .linkDeleted,
        object: nil,
        queue: .main
      ) { notification in
        store.send(.showDeleteAlert("링크를 삭제했어요"))
        store.send(.fetchArticles)
      }
    }
    .overlay(alignment: .bottom) {
      if store.showToast {
        AlertBanner(
          text: "링크를 저장했어요!",
          message: store.toastMessage,
          style: .common
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
      }
      if let message = store.deleteAlert {
        AlertIconBanner(
          icon: Image(icon: Icon.info),
          title: message,
          iconColor: .danger
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
      }
    }
    .animation(.easeInOut(duration: 0.3), value: store.showToast)
    .animation(.easeInOut(duration: 0.3), value: store.deleteAlert)
  }
}
