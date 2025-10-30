//
//  OriginalEditRouteBuilder.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import ComposableArchitecture
import Domain
import LinkNavigator
import SwiftUI

public struct OriginalEditRouteBuilder {
  public init() { }
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.originalEdit.rawValue
    
    return .init(matchPath: matchPath) { navigator, item, _ -> RouteViewController? in
      
      let trimmedItem = item.trimmingCharacters(in: .whitespacesAndNewlines)
      
      guard
        let data = Data(base64Encoded: trimmedItem),
        let decoded = String(data: data, encoding: .utf8)?
          .replacingOccurrences(of: "\\/", with: "/")
          .replacingOccurrences(of: "\"", with: ""),
        let url = URL(string: decoded)
      else {
        return WrappingController(matchPath: matchPath) {
          Text("Invalid URL")
        }
      }
      
      return WrappingController(matchPath: matchPath) {
        OriginalEditView(
          store: Store(initialState: OriginalEditFeature.State(url: url), reducer: {
          OriginalEditFeature()
              .dependency(\.linkNavigator, .init(navigator: navigator))
        }))
      }
    }
  }
}
