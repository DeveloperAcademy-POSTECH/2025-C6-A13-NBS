//
//  OnboardingServiceRouteBuilder.swift
//  Nbs
//
//  Created by 홍 on 11/7/25.
//

import ComposableArchitecture
import LinkNavigator
import Feature

public struct OnboardingServiceRouteBuilder {
  
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.onboardingService.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      return WrappingController(matchPath: matchPath) {
        OnboardingServiceView(store: Store(initialState: OnboardingServiceFeature.State()) {
          OnboardingServiceFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
