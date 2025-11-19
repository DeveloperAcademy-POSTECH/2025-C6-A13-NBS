//
//  ExtensionSettingRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 11/12/25.
//

import ComposableArchitecture
import LinkNavigator

public struct ExtensionSettingRouteBuilder {
  public init() {}

  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.extensionSetting.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ in
      WrappingController(matchPath: matchPath) {
        ExtensionSettingView(
          store: Store(
            initialState: ExtensionSettingFeature.State()
          ) {
            ExtensionSettingFeature()
              .dependency(\.linkNavigator, .init(navigator: navigator))
          }
        )
      }
    }
  }
}
