//
//  OnboardingHighlightRouteBuilder.swift
//  Nbs
//
//  Created by 홍 on 11/8/25.
//

import ComposableArchitecture
import LinkNavigator
import Feature

public struct OnboardingHighlightGuideRouteBuilder {
  
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.highlightMemoGuide.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      return WrappingController(matchPath: matchPath) {
        OnboardingHighlightGuideView(store: Store(initialState: OnboardingHighlightGuideFeature.State()) {
          OnboardingHighlightGuideFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
