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
    return .init(matchPath: matchPath) { navigator, item, data -> RouteViewController? in
      let movedInfo = data as? [String: Bool]
      let didMove = movedInfo?["moved"] ?? false
      
      return WrappingController(matchPath: matchPath) {
        LinkListView(
          store: Store(
            initialState: LinkListFeature.State(didMoveLink: didMove)
          ) {
          LinkListFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
