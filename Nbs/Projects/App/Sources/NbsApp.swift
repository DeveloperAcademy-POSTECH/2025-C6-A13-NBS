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
  
  var body: some Scene {
    WindowGroup {
      LinkNavigationView(
        linkNavigator: singleNavigator,
        item: .init(path: Route.home.rawValue))
      .ignoresSafeArea()
//      ZStack {
//        if showSplash {
//          SplashView()
//        } else {
//          LinkNavigationView(
//            linkNavigator: singleNavigator,
//            item: .init(path: Route.home.rawValue))
//          .ignoresSafeArea()
//        }
//      }
//      .modelContainer(AppGroupContainer.shared)
//      .onAppear {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//          withAnimation(.easeOut(duration: 0.3)) {
//            showSplash = false
//          }
//        }
//      }
    }
  }
}
