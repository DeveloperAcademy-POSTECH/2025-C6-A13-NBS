//
//  TopAppBarIconxView.swift
//  Feature
//
//  Created by 홍 on 10/18/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

public struct TopAppBarDefaultRightIconxFeatureView {
  let store: StoreOf<TopAppBarDefaultRightIconxFeature>
  
  public init(store: StoreOf<TopAppBarDefaultRightIconxFeature>) {
    self.store = store
  }
}

extension TopAppBarDefaultRightIconxFeatureView: View {
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TopAppBarDefaultRightIconx(
        title: viewStore.title,
        onTapBackButton: { viewStore.send(.tapBackButton) }
      )
    }
  }
}
