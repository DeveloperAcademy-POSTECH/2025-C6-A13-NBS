//
//  MyCategoryRouteBuilder.swift
//  Feature
//
//  Created by 홍 on 10/26/25.
//

import LinkNavigator
import ComposableArchitecture

public struct MyCategoryRouteBuilder {

  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = "myCategory"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        MyCategoryCollectionView(store: Store(initialState: MyCategoryCollectionFeature.State()) {
          MyCategoryCollectionFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
