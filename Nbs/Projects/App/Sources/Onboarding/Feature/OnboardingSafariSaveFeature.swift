//
//  OnboardingSaveFeature.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import ComposableArchitecture
import LinkNavigator

@Reducer
struct OnboardingSafariSaveFeature {
  @Dependency(\.linkNavigator) var navigation
  
  @ObservableState
  struct State {
    var currentPage: Int = 3
    var isReady: Bool = false
  }
  
  enum Action {
    case backButtonTapped
    case completeButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { send in
          await navigation.pop()
        }
      case .completeButtonTapped:
        navigation.push(.startApp, nil)
        return .none
      }
    }
  }
}
