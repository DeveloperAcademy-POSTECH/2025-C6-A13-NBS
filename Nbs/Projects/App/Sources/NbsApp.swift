import SwiftUI

import SwiftData

import Domain
import Feature

@main
struct NbsApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      LinkItem.self,
      HighlightItem.self,
      Category.self
    ])
    
    let appGroupID = "group.com.nbs.dev.ADA.shared"
    guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
      fatalError("Could not access App Group container.")
    }
    let storeURL = containerURL.appendingPathComponent("Nbs_store.sqlite")
    let configuration = ModelConfiguration(schema: schema, url: storeURL)
    
    do {
      return try ModelContainer(for: schema, configurations: [configuration])
    } catch {
      fatalError("Could not create shared ModelContainer: \(error)")
    }
  }()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(sharedModelContainer)
  }
}
