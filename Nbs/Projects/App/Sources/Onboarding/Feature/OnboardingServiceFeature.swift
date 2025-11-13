//
//  OnboardingServiceFeature.swift
//  Nbs
//
//  Created by 홍 on 11/7/25.
//

import ComposableArchitecture
import LinkNavigator

@Reducer
struct OnboardingServiceFeature {
  @Dependency(\.linkNavigator) var navigation
  
  @ObservableState
  struct State {
    
  }
  
  enum Action {
    case startButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .startButtonTapped:
        navigation.replace([.onboarding], nil)
        return .none
      }
    }
  }
}
