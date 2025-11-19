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
  
  var launchState: LaunchState {
    if showSplash {
      return .splash
    }
    
    let hasSeen = UserDefaults.standard.bool(forKey: UserDefaultsKey.onboarding)
    return hasSeen ? .home : .onboarding
  }
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        switch launchState {
        case .splash:
          SplashView()
            .transition(.opacity)
            .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.55) {
                self.showSplash = false
              }
            }
          
        case .onboarding:
          LinkNavigationView(
            linkNavigator: singleNavigator,
            item: .init(path: Route.onboardingService.rawValue)
          )
          .ignoresSafeArea()
          .transition(.opacity)
          
        case .home:
          LinkNavigationView(
            linkNavigator: singleNavigator,
            item: .init(path: Route.home.rawValue)
          )
          .ignoresSafeArea()
          .transition(.opacity)
        }
      }
      .animation(.easeInOut(duration: 0.3), value: launchState)
    }
  }
}
