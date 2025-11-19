//
//  LinkListRouteBuilder.swift
//  Feature
//
//  Created by 이안 on 10/28/25.
//

import LinkNavigator
import ComposableArchitecture
import Domain

public struct LinkListRouteBuilder {
  public init() {}
  
  @MainActor
  public func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = Route.linkList.rawValue
    return .init(matchPath: matchPath) { navigator, item, data -> RouteViewController? in
      
      let payload: LinkListPayload? = item.decoded()
      let categoryName = payload?.categoryName
      
      var state = LinkListFeature.State()
      if let name = categoryName {
        state.selectedCategory = CategoryItem(categoryName: name, icon: .init(number: 0))
      }
      
      return WrappingController(matchPath: matchPath) {
        LinkListView(
          store: Store(
            initialState: state
          ) {
            LinkListFeature()
              .dependency(\.linkNavigator, .init(navigator: navigator))
          })
      }
    }
  }
}
