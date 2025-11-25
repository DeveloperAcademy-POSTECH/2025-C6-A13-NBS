//
//  ExtensionSettingFeature.swift
//  Feature
//
//  Created by 이안 on 11/12/25.
//

import ComposableArchitecture
import LinkNavigator
import Domain

@Reducer
struct ExtensionSettingFeature {
  @Dependency(\.linkNavigator) var navigation
  
  @ObservableState
  struct State {
    var currentPage: Int = 1
  }
  
  enum Action {
    case settingButtonTapped
    case backButtonTapped
    case naviPush
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { send in
          await navigation.pop()
        }
      case .settingButtonTapped:
        return .none
      case .naviPush:
        return .none
      }
    }
  }
}
