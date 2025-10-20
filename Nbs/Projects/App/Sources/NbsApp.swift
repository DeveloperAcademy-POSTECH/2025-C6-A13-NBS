import SwiftUI
import SwiftData
import Domain
import Feature

@main
struct NbsApp: App {
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
      HomeEntryView()
    }
    .modelContainer(AppGroupContainer.shared)
  }
}
