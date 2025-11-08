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
      //MARK: 온보딩
      OnboardingServiceRouteBuilder().generate(),
      OnboardingRouteBuilder().generate(),
      OnboardingHighlightGuideRouteBuilder().generate(),
      
      //MARK: 앱
      HomeRouteBuilder().generate(),
      AddLinkRouteBuilder().generate(),
      MyCategoryRouteBuilder().generate(),
      AddCategoryRouteBuilder().generate(),
      EditCategoryRouteBuilder().generate(),
      DeleteCategoryRouteBuilder().generate(),
      CategorySettingRouteBuilder().generate(),
      SearchRouteBuilder().generate(),
      EditCategoryIconNameRouteBuilder().generate(),
      LinkListRouteBuilder().generate(),
      LinkDetailRouteBuilder().generate(),
      OriginalArticleRouteBuilder().generate(),
      OriginalEditRouteBuilder().generate(),
      SettingRouteBuilder().generate(),
      PolicyDetailRouteBuilder().generate(),
      OpenSourceListRouteBuilder().generate(),
      MoveLinkRouteBuilder().generate(),
      DeleteLinkRouteBuilder().generate()
    ]
  }
}
