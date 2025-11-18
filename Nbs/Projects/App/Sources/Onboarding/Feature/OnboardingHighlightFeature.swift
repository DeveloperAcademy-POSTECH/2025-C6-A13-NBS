//
//  OnboardingHighlightFeature.swift
//  Nbs
//
//  Created by 홍 on 11/8/25.
//

import Foundation

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
    var showDimming: Bool = false
    var isTextHighlighted: Bool = false
    var showToolTip: Bool = true
    var showMemo = false
  }
  
  enum Action {
    case backButtonTapped
    case finishButtonTapped
    case onAppear
    case taptap
    case memoButtonTapped
    case hideMemo
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.showDimming = true
        return .none
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
          navigation.remove(.onboardingHighlight)
          return .none
        }
      case .taptap:
        state.showDimming = false
        return .none
      case .memoButtonTapped:
        state.showMemo = true
        return .run { send in
          try await Task.sleep(nanoseconds: 500_000_000)
          await send(.hideMemo)
        }
      case .hideMemo:
        state.showMemo = true
        return .none
      }
    }
  }
}
