//
//  OpenSourceListRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 11/6/25.
//

import ComposableArchitecture
import LinkNavigator

public struct OpenSourceListRouteBuilder {
  public init() {}

  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.openSourceList.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ in
      WrappingController(matchPath: matchPath) {
        OpenSourceListView(
          store: Store(
            initialState: OpenSourceListFeature.State()
          ) {
            OpenSourceListFeature()
              .dependency(\.linkNavigator, .init(navigator: navigator))
          }
        )
      }
    }
  }
}
