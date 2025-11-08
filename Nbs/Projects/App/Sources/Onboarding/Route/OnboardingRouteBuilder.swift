//
//  OnboardingSafariSettingRouteBuilder.swift
//  Nbs
//
//  Created by 홍 on 11/7/25.
//

import ComposableArchitecture
import LinkNavigator
import Feature

public struct OnboardingRouteBuilder {
  
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.onboarding.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      return WrappingController(matchPath: matchPath) {
        OnboardingView(store: Store(initialState: OnboardingFeature.State()) {
          OnboardingFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
