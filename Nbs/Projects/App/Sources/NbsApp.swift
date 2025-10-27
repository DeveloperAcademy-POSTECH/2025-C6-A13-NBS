import SwiftUI
import SwiftData

import Domain
import Feature
import LinkNavigator

@main
struct NbsApp: App {
  let singleNavigator = SingleLinkNavigator(
    routeBuilderItemList: AppRouterGroup().routers(),
    dependency: AppDependency(modelContainer: AppGroupContainer.shared)
  )
//  let sharedModelContainer: ModelContainer
//
//  init() {
//      guard let container = AppGroupContainer.createShareModelContainer() else {
//          fatalError("Failed to create shared ModelContainer.")
//      }
//      self.sharedModelContainer = container
//  }
  
  var body: some Scene {
    WindowGroup {
      LinkNavigationView(
        linkNavigator: singleNavigator,
        item: .init(path: "home"))
      .ignoresSafeArea()
    }
    .modelContainer(AppGroupContainer.shared)
  }
}
