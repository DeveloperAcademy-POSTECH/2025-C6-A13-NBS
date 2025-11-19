//
//  TopAppBarDefautView.swift
//  Feature
//
//  Created by 홍 on 10/18/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct TopAppBarDefautView {
  let store: StoreOf<TopAppBarDefaultFeature>
  
  public init(store: StoreOf<TopAppBarDefaultFeature>) {
    self.store = store
  }
}

extension TopAppBarDefautView: View {
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TopAppBarDefault(
        title: viewStore.title,
        onTapBackButton: { viewStore.send(.tapBackButton) },
        onTapSearchButton: { viewStore.send(.tapSearchButton) },
        onTapSettingButton: { viewStore.send(.tapSettingButton) }
      )
    }
  }
}
