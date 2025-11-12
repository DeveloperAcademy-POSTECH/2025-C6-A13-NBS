//
//  ShareSettingFeature.swift
//  Feature
//
//  Created by 이안 on 11/12/25.
//

import ComposableArchitecture
import LinkNavigator
import Domain

@Reducer
struct ShareSettingFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State { }
  
  enum Action: Equatable {
    case backButtonTapped
  }
  
  init() {}
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { _ in
          await linkNavigator.pop()
        }
      }
    }
  }
}
