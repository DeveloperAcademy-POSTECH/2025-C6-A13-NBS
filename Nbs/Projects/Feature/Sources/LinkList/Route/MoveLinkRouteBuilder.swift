//
//  MoveLinkRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 11/7/25.
//

import LinkNavigator
import ComposableArchitecture
import Domain

public struct MoveLinkRouteBuilder {
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.moveLink.rawValue
    return .init(matchPath: matchPath) { navigator, item, _ -> RouteViewController? in
      let payload: LinkListPayload? = item.decoded()
      
      return WrappingController(matchPath: matchPath) {
        MoveLinkView(
          store: Store(
            initialState: MoveLinkFeature.State(
              allLinks: payload?.links ?? [],
              categoryName: payload?.categoryName ?? "전체"
              )
          ) {
            MoveLinkFeature()
              .dependency(\.linkNavigator, .init(navigator: navigator))
          })
      }
    }
  }
}

