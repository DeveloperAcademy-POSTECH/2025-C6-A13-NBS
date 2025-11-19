//
//  OpenSourceListView.swift
//  Feature
//
//  Created by 이안 on 11/6/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct OpenSourceListView: View {
  @Bindable var store: StoreOf<OpenSourceListFeature>
}

extension OpenSourceListView {
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      
      VStack(spacing: .zero) {
        naivgationBar
        openSourceList
        Spacer()
      }
    }
  }
  
  private var naivgationBar: some View {
    TopAppBarDefaultRightIconx(
      title: "사용된 오픈소스",
      onTapBackButton: { store.send(.backButtonTapped) }
    )
  }
  
  private var openSourceList: some View {
    VStack(spacing: .zero) {
      InfoListItem(
        icon: Icon.opensource,
        title: "Composable Architecture",
        trailing: .chevron
      ) {
        store.send(.libraryTapped("https://github.com/pointfreeco/swift-composable-architecture"))
      }
      
      InfoListItem(
        icon: Icon.opensource,
        title: "Tuist",
        trailing: .chevron
      ) {
        store.send(.libraryTapped("https://github.com/tuist/tuist"))
      }
      
      InfoListItem(
        icon: Icon.opensource,
        title: "LinkNavigator",
        trailing: .chevron
      ) {
        store.send(.libraryTapped("https://github.com/forXifLess/LinkNavigator"))
      }
    }
    .padding(.horizontal, 20)
  }
}
