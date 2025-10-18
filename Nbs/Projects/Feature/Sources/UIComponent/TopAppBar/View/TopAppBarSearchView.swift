//
//  TopAppBarSearchView.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct TopAppBarSearchView {
  let store: StoreOf<TopAppBarSearchFeature>
}

extension TopAppBarSearchView: View {
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TopAppBarSearch(
        text: viewStore.$searchText,
        onBack: { viewStore.send(.backTapped) },
        onSubmit: { viewStore.send(.submit) },
        onClear: { viewStore.send(.clear) }
      )
    }
  }
}
