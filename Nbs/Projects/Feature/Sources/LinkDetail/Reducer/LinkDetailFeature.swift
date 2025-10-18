//
//  LinkDetailFeature.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import ComposableArchitecture

@Reducer
struct LinkDetailFeature {
  @ObservableState
  struct State {
    var articleTitle: String = ""
  }
  
  enum Action {
    case onAppear
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
      }
    }
  }
}
