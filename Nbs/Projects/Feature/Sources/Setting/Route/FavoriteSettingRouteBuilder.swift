//
//  FavoriteSettingRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 11/12/25.
//

import ComposableArchitecture
import LinkNavigator

public struct FavoriteSettingRouteBuilder {
  public init() {}

  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.favoriteSetting.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ in
      WrappingController(matchPath: matchPath) {
        FavoriteSettingView(
          store: Store(
            initialState: FavoriteSettingFeature.State()
          ) {
            FavoriteSettingFeature()
              .dependency(\.linkNavigator, .init(navigator: navigator))
          }
        )
      }
    }
  }
}
