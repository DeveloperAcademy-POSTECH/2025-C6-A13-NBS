//
//  OriginalRouteBuilder.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import ComposableArchitecture
import Domain
import LinkNavigator
import SwiftUI

public struct OriginalArticleRouteBuilder {
  public init() { }
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.originalArticle.rawValue
    
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
        OriginalArticleView(
          store: Store(initialState: OriginalArticleFeature.State(url: url), reducer: {
          OriginalArticleFeature()
              .dependency(\.linkNavigator, .init(navigator: navigator))
        }))
      }
    }
  }
}
