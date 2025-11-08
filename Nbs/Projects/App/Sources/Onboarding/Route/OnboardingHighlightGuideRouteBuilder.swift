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
        OnboardingHighlightView(store: Store(initialState: OnboardingHighlightFeature.State()) {
          OnboardingHighlightFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
