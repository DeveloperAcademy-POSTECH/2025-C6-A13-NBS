//
//  AddNewCategoryRouteBuilder.swift
//  Feature
//
//  Created by 홍 on 10/26/25.
//

import LinkNavigator
import ComposableArchitecture

public struct AddCategoryRouteBuilder {

  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = "addCategory"
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
