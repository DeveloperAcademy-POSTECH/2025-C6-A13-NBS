//
//  EditCategoryIconNameRouteBuilder.swift
//  Feature
//
//  Created by 홍 on 10/27/25.
//

import LinkNavigator
import ComposableArchitecture

public struct EditCategoryIconNameRouteBuilder {

  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.deleteCategory.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        EditCategoryIconNameView(store: Store(initialState: EditCategoryIconNameFeature.State(category: category)) {
          EditCategoryIconNameFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
//        DeleteCategoryView(store: Store(initialState: DeleteCategoryFeature.State()) {
//          DeleteCategoryFeature()
//          .dependency(\.linkNavigator, .init(navigator: navigator))
//        })
      }
    }
  }
}
