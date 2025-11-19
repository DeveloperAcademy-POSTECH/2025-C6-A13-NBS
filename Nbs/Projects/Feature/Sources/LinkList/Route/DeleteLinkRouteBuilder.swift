//
//  DeleteLinkRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 11/8/25.
//

import LinkNavigator
import ComposableArchitecture
import Domain

public struct DeleteLinkRouteBuilder {
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.deleteLink.rawValue
    return .init(matchPath: matchPath) { navigator, item, _ -> RouteViewController? in
      let payload: LinkListPayload? = item.decoded()
      
      return WrappingController(matchPath: matchPath) {
        DeleteLinkView(
          store: Store(
            initialState: DeleteLinkFeature.State(
              allLinks: payload?.links ?? [],
              categoryName: payload?.categoryName ?? "전체"
            )
          ) {
            DeleteLinkFeature()
              .dependency(\.linkNavigator, .init(navigator: navigator))
          })
      }
    }
  }
}
