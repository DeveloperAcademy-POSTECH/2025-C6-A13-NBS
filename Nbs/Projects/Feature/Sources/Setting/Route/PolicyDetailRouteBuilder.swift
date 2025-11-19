//
//  PolicyDetailRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 11/5/25.
//

import SwiftUI

import ComposableArchitecture
import LinkNavigator
import Domain
import DesignSystem

public struct PolicyDetailRouteBuilder {
  
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.policyDetail.rawValue
    
    return .init(matchPath: matchPath) { navigator, item, _ -> RouteViewController? in
      let decoded: PolicyDetailPayload? = item.decoded()
      return WrappingController(matchPath: matchPath) {
        PolicyDetailView(
          store: Store(
            initialState: PolicyDetailFeature.State(
              title: decoded?.title ?? "정책",
              text: decoded?.text ?? ""
            )
          ) {
            PolicyDetailFeature()
              .dependency(\.linkNavigator, .init(navigator: navigator))
          }
        )
      }
    }
  }
}
