//
//  DeleteCategoryRouteBuilder.swift
//  Feature
//
//  Created by 홍 on 10/27/25.
//

import LinkNavigator
import ComposableArchitecture

public struct DeleteCategoryRouteBuilder {

  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.deleteCategory.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        DeleteCategoryView(store: Store(initialState: DeleteCategoryFeature.State()) {
          DeleteCategoryFeature()
          .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
