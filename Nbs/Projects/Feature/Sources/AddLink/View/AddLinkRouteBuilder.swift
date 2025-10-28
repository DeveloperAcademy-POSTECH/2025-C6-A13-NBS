//
//  AddLinkRouteBuilder.swift
//  Feature
//
//  Created by 홍 on 10/26/25.
//

import SwiftUI

import LinkNavigator
import ComposableArchitecture

public struct AddLinkRouteBuilder {

  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.addLink.rawValue
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        AddLinkView(store: Store(initialState: AddLinkFeature.State()) {
          AddLinkFeature()
            .dependency(\.linkNavigator, .init(navigator: navigator))
        })
      }
    }
  }
}
