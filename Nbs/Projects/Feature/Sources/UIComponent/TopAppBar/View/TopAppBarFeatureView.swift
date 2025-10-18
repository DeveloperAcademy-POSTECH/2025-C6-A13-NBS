//
//  TopAppBarFeatureView.swift
//  Feature
//
//  Created by 홍 on 10/18/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

public struct TopAppBarFeatureView {
  let store: StoreOf<TopAppBarButtonFeature>
  
  public init(store: StoreOf<TopAppBarButtonFeature>) {
    self.store = store
  }
}

extension TopAppBarFeatureView: View {
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TopAppBarButton(isEditing: viewStore.isEditing) {
        viewStore.send(.tapEditButton)
      } onTapBackButton: {
        viewStore.send(.tapBackButton)
      }
    }
  }
}
