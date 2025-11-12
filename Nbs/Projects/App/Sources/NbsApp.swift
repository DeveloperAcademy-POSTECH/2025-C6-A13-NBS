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
      ZStack {
        if showSplash {
          SplashView()
            .transition(.opacity)
            .zIndex(1)
            .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.55) {
                self.showSplash = false
              }
            }
        } else {
          if hasSeen {
            LinkNavigationView(
              linkNavigator: singleNavigator,
              item: .init(path: Route.home.rawValue))
            .ignoresSafeArea()
            .transition(.opacity)
          } else {
            LinkNavigationView(
              linkNavigator: singleNavigator,
              item: .init(path: Route.onboardingService.rawValue))
            .ignoresSafeArea()
            .transition(.opacity)
          }
        }
      }
      .animation(.easeInOut(duration: 0.3), value: showSplash)
    }
  }
}

