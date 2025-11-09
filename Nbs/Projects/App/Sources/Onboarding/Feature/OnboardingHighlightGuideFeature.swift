//
//  OnboardingHighlightGuideFeature.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import ComposableArchitecture
import LinkNavigator

@Reducer
struct OnboardingHighlightGuideFeature {
  @Dependency(\.linkNavigator) var navigation
  
  @ObservableState
  struct State {
    var currentPage: Int = 2
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
        navigation.push(.onboardingHighlight, nil)
        return .none
      case .skipButtonTapped:
        navigation.push(.safariShare, nil)
        return .none
      }
    }
  }
}
