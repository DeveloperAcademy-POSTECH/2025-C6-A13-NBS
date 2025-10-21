
import Foundation
import SwiftData
import ComposableArchitecture

import Domain

struct SwiftDataClient {
  // LinkItem
  var fetchLinks: () throws -> [LinkItem]
  var searchLinks: (String) throws -> [LinkItem]
  var addLink: (LinkItem) throws -> Void
  
  // CategoryItem
  var fetchCategories: () throws -> [CategoryItem]
  var addCategory: (CategoryItem) throws -> Void
}

extension SwiftDataClient: DependencyKey {
  static let liveValue: Self = {
    let modelContainer = AppGroupContainer.shared
    let modelContext = ModelContext(modelContainer)
    
    return Self(
      fetchLinks: {
        let descriptor = FetchDescriptor<LinkItem>()
        return try modelContext.fetch(descriptor)
      },
      searchLinks: { query in
        let predicate = #Predicate<LinkItem> {
          $0.title.contains(query)
        }
        let descriptor = FetchDescriptor<LinkItem>(predicate: predicate)
        return try modelContext.fetch(descriptor)
      },
      addLink: { link in
        modelContext.insert(link)
        try modelContext.save()
      },
      fetchCategories: {
        let descriptor = FetchDescriptor<CategoryItem>()
        return try modelContext.fetch(descriptor)
      },
      addCategory: { category in
        modelContext.insert(category)
        try modelContext.save()
      }
    )
  }()
}

extension DependencyValues {
  var swiftDataClient: SwiftDataClient {
    get { self[SwiftDataClient.self] }
    set { self[SwiftDataClient.self] = newValue }
  }
}
