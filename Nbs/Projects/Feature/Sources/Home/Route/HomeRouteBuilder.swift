//
//  HomeRouterBuilder.swift
//  Feature
//
//  Created by 홍 on 10/26/25.
//

import SwiftUI

import ComposableArchitecture
import LinkNavigator

public struct HomeRouteBuilder {
  
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.home.rawValue
    
    return .init(
      matchPath: matchPath) {
        navigator,
        _,
        _ -> RouteViewController? in
        WrappingController(matchPath: matchPath) {
          HomeEntryView(navigator: navigator)
        }
      }
  }
}
