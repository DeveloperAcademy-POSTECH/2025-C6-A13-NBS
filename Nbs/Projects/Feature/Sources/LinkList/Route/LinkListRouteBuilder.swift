//
//  LinkListRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 10/28/25.
//

import LinkNavigator
import ComposableArchitecture

public struct LinkListRouteBuilder {
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.linkList.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        LinkListView(store: Store(initialState: LinkListFeature.State()) {
          LinkListFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
