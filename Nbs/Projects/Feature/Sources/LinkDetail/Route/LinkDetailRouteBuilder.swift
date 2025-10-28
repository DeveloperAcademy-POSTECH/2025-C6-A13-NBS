//
//  LinkDetailRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 10/28/25.
//

import ComposableArchitecture
import LinkNavigator

public struct LinkDetailRouteBuilder {
  
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.linkDetail.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        LinkDetailView(store: Store(initialState: LinkDetailFeature.State(link: <#ArticleItem#>)) {
          LinkDetailFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
