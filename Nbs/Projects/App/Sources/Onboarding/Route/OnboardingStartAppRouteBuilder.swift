//
//  OnboardingStartAppRouteBuilder.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import ComposableArchitecture
import LinkNavigator
import Feature

public struct OnboardingStartAppRouteBuilder {
  
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.startApp.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      return WrappingController(matchPath: matchPath) {
        OnboardingStartAppView()
//            .dependency(\.linkNavigator, .init(navigator: navigator))
      }
    }
  }
}
