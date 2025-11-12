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
      OnboardingHighlightRouteBuilder().generate(),
      OnboardingSafariShareRouteBuilder().generate(),
      OnboardingSafariSaveRouteBuilder().generate(),
      OnboardingStartAppRouteBuilder().generate(),
      
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
      MoveLinkRouteBuilder().generate(),
      DeleteLinkRouteBuilder().generate(),
      
      // MARK: - 설정
      SettingRouteBuilder().generate(),
      PolicyDetailRouteBuilder().generate(),
      OpenSourceListRouteBuilder().generate(),
      FavoriteSettingRouteBuilder().generate(),
      ExtensionSettingRouteBuilder().generate(),
      ShareSettingRouteBuilder().generate()
    ]
  }
}
