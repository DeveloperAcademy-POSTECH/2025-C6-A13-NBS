import Foundation
import SwiftData

public enum AppGroupContainer {
    public static func createShareModelContainer() -> ModelContainer? {
        let appGroupID = "group.com.nbs.dev.ADA.shared"
        let schema = Schema([LinkItem.self, HighlightItem.self, CategoryItem.self])
        
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            print("Error: Failed to get container URL for App Group ID: \(appGroupID)")
            return nil
        }
        
        let storeURL = containerURL.appendingPathComponent("Nbs_store.sqlite")
        let configuration = ModelConfiguration(schema: schema, url: storeURL)
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            print("Error creating ModelContainer: \(error)")
            return nil
        }
    }
}
