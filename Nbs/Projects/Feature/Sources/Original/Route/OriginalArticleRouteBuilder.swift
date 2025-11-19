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
    
      guard let data = Data(base64Encoded: trimmedItem),
            let payload = try? JSONDecoder().decode(OriginalPayload.self, from: data),
            let url = URL(string: payload.articleItem.urlString)
      else {
        return WrappingController(matchPath: matchPath) {
          Text("Invalid Data")
        }
      }
      
      return WrappingController(matchPath: matchPath) {
        OriginalArticleView(
          store: Store(initialState: OriginalArticleFeature.State(articleItem: payload.articleItem), reducer: {
          OriginalArticleFeature()
              .dependency(\.linkNavigator, .init(navigator: navigator))
        }))
      }
    }
  }
}
