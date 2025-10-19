
//
//  AddLinkFeature.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AddLinkFeature {
  
  @Dependency(\.dismiss) var dismiss
  
  @ObservableState
  struct State {
    var topAppBar = TopAppBarDefaultRightIconxFeature.State(title: "링크 추가하기")
  }
  
  enum Action {
    case topAppBar(TopAppBarDefaultRightIconxFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.topAppBar, action: \.topAppBar) {
      TopAppBarDefaultRightIconxFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .topAppBar(.tapBackButton):
        return .run { _ in await self.dismiss() }
        
      case .topAppBar:
        return .none
      }
    }
  }
}
