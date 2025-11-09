//
//  OnboardingHighlightFeature.swift
//  Nbs
//
//  Created by 홍 on 11/8/25.
//

import ComposableArchitecture
import LinkNavigator

@Reducer
struct OnboardingHighlightFeature {
  @Dependency(\.linkNavigator) var navigation
  
  @ObservableState
  struct State {
    var currentPage: Int = 2
  }
  
  enum Action {
    case backButtonTapped
    case finishButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { send in
          await navigation.pop()
        }
      case .finishButtonTapped:
        navigation.push(.safariShare, nil)
        return .none
      }
    }
  }
}
