//
//  OnboardingStartAppFeature.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import ComposableArchitecture
import LinkNavigator
import Foundation

@Reducer
struct OnboardingStartAppFeature {
  @Dependency(\.linkNavigator) var navigation
  
  @ObservableState
  struct State {}
  
  enum Action {
    case startButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .startButtonTapped:
        UserDefaults.standard.set(true, forKey: "onboarding")
        navigation.push(.home, nil)
        return .none
      }
    }
  }
}

