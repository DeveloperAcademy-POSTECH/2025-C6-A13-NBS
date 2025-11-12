import SwiftUI
import SwiftData

import Domain
import Feature
import LinkNavigator

@main
struct NbsApp: App {
  @State private var showSplash = true
  
  let singleNavigator = SingleLinkNavigator(
    routeBuilderItemList: AppRouterGroup().routers(),
    dependency: AppDependency()
  )
  
  let hasSeen = UserDefaults.standard.bool(forKey: "onboarding")
  
  var body: some Scene {
    WindowGroup {
      if hasSeen {
        LinkNavigationView(
          linkNavigator: singleNavigator,
          item: .init(path: Route.home.rawValue))
        .ignoresSafeArea()
      } else {
        LinkNavigationView(
          linkNavigator: singleNavigator,
          item: .init(path: Route.onboardingService.rawValue))
        .ignoresSafeArea()
      }
    }
  }
}
