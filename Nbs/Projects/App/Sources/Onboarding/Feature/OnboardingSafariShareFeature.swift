//
//  OnboardingSafariShareFeature.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import ComposableArchitecture
import LinkNavigator

@Reducer
struct OnboardingSafariShareFeature {
  @Dependency(\.linkNavigator) var navigation
  
  @ObservableState
  struct State {
    var currentPage: Int = 3
  }
  
  enum Action {
    case backButtonTapped
    case nextButtonTapped
    case skipButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { send in
          await navigation.pop()
        }
      case .nextButtonTapped:
        navigation.push(.safariSave, nil)
        return .none
      case .skipButtonTapped:
        navigation.push(.startApp, nil)
        return .none
      }
    }
  }
}
