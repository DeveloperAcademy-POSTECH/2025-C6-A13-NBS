//
//  TopAppBarDefaultNoSearchView.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct TopAppBarDefaultNoSearchView {
  let store: StoreOf<TopAppBarDefaultNoSearchFeature>
  
  public init(store: StoreOf<TopAppBarDefaultNoSearchFeature>) {
    self.store = store
  }
}

extension TopAppBarDefaultNoSearchView: View {
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TopAppBarDefaultNoSearch(
        title: viewStore.title,
        onTapBackButton: { viewStore.send(.tapBackButton) },
        onTapSettingButton: { viewStore.send(.tapSettingButton) }
      )
    }
  }
}
