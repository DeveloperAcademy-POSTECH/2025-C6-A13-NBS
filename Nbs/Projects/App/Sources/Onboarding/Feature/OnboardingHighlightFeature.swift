//
//  OnboardingHighlightFeature.swift
//  Nbs
//
//  Created by 홍 on 11/8/25.
//

import ComposableArchitecture
import LinkNavigator
import Feature

@Reducer
struct OnboardingHighlightFeature {
  @Dependency(\.linkNavigator) var navigation
  
  @ObservableState
  struct State {
    var currentPage: Int = 2
    var entryPoint: Route? = .home
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
        if state.entryPoint == .home {
          return .run { send in
            await navigation.pop()
          }
        } else {
          navigation.push(.safariShare, nil)
          return .none
        }
      }
    }
  }
}
