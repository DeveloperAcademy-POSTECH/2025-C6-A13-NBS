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
    var appForground: Bool = false
    var videoChecked: Bool = false
  }
  
  enum Action {
    case settingButtonTapped
    case backButtonTapped
    case alertCancelButtonTapped
    case alertSkipButtonTapped
    case naviPush
    case nextButtonTapped
    case onAppear
    case showVideo
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .showVideo:
        state.videoChecked = true
        return .none
      case .onAppear:
        state.videoChecked = false
        return .none
      case .nextButtonTapped:
        state.isAlert = true
        
        return .none
      case .backButtonTapped:
        return .run { send in
          await navigation.pop()
        }
      case .settingButtonTapped:
        return .none
      case .alertCancelButtonTapped:
        state.isAlert = false
        return .none
      case .alertSkipButtonTapped:
        state.isAlert = false
        navigation.push(.highlightMemoGuide, nil)
        return .none
      case .naviPush:
        navigation.push(.highlightMemoGuide, nil)
        return .none
      }
    }
  }
}
