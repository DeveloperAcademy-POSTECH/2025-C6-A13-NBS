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
    var currentPage: Int = 1
    var isAlert: Bool = false
  }
  
  enum Action {
    case settingButtonTapped
    case backButtonTapped
    case skipButtonTapped
    case alertCancelButtonTapped
    case alertSkipButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .skipButtonTapped:
        state.isAlert = true
        return .none
      case .backButtonTapped:
        return .run { send in
          await navigation.pop()
        }
      case .settingButtonTapped:
//        navigation.push(.highlightMemoGuide, nil)
        return .none
      case .alertCancelButtonTapped:
        state.isAlert = false
        return .none
      case .alertSkipButtonTapped:
        state.isAlert = false
        navigation.push(.highlightMemoGuide, nil)
        return .none
      }
    }
  }
}
