//
//  ShareSettingRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 11/12/25.
//

import ComposableArchitecture
import LinkNavigator

public struct ShareSettingRouteBuilder {
  public init() {}

  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.shareSetting.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ in
      WrappingController(matchPath: matchPath) {
        ShareSettingView(
          store: Store(
            initialState: ShareSettingFeature.State()
          ) {
            ShareSettingFeature()
              .dependency(\.linkNavigator, .init(navigator: navigator))
          }
        )
      }
    }
  }
}
