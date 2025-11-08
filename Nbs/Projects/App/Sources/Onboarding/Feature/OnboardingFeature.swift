//
//  OnboardingSafariSettingFeature.swift
//  Nbs
//
//  Created by 홍 on 11/7/25.
//

import ComposableArchitecture
import LinkNavigator

@Reducer
struct OnboardingFeature {
  @Dependency(\.linkNavigator) var navigation
  
  @ObservableState
  struct State {
    
  }
  
  enum Action {
    case startButtonTapped
    case backButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { send in
          await navigation.pop()
        }
      case .startButtonTapped:
        navigation.push(.safariSetting, nil)
        return .none
      }
    }
  }
}
