//
//  CategorySettingRouteBuilder.swift
//  Feature
//
//  Created by 홍 on 10/27/25.
//

import SwiftUI

import ComposableArchitecture
import LinkNavigator

public struct CategorySettingRouteBuilder {

  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.categorySetting.rawValue
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
