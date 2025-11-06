//
//  SettingRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 11/5/25.
//

import ComposableArchitecture
import LinkNavigator

public struct SettingRouteBuilder {
  
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.setting.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        SettingView(store: Store(initialState: SettingFeature.State(), reducer: {
          SettingFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        }))
      }
    }
  }
}
