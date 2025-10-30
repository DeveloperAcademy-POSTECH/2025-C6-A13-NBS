//
//  AppRouterGroup.swift
//  Nbs
//
//  Created by 홍 on 10/26/25.
//

import Feature
import LinkNavigator

public struct AppRouterGroup {
  public init() { }
}

extension AppRouterGroup {

  @MainActor
  func routers() -> [RouteBuilderOf<SingleLinkNavigator>] {
    [
      HomeRouteBuilder().generate(),
      AddLinkRouteBuilder().generate(),
      MyCategoryRouteBuilder().generate(),
      AddCategoryRouteBuilder().generate(),
      EditCategoryRouteBuilder().generate(),
      DeleteCategoryRouteBuilder().generate(),
      SettingRouteBuilder().generate(),
      EditCategoryIconNameRouteBuilder().generate(),
      LinkListRouteBuilder().generate(),
      LinkDetailRouteBuilder().generate(),
      OriginalArticleRouteBuilder().generate(),
      OriginalEditRouteBuilder().generate()
    ]
  }
}
