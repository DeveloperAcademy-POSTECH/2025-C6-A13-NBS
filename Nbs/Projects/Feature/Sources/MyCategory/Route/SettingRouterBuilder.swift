//
//  SettingRouterBuilder.swift
//  Feature
//
//  Created by 홍 on 10/27/25.
//

import SwiftUI

import ComposableArchitecture
import LinkNavigator

public struct SettingRouteBuilder {

  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.setting.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        AddCategoryView(store: Store(initialState: AddCategoryFeature.State()) {
          AddCategoryFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
