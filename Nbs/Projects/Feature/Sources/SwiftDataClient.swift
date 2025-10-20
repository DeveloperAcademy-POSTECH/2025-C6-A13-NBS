
import Foundation
import SwiftData
import ComposableArchitecture

import Domain

struct SwiftDataClient {
  var fetchCategories: () throws -> [CategoryItem]
  var addCategory: (CategoryItem) throws -> Void
  var addLink: (LinkItem) throws -> Void
  var fetchLinkItem: () throws -> [LinkItem]
}

extension SwiftDataClient: DependencyKey {
  static let liveValue: Self = {
    let modelContainer = AppGroupContainer.shared
    let modelContext = ModelContext(modelContainer)
    
    return Self(
      fetchCategories: {
        let descriptor = FetchDescriptor<CategoryItem>()
        return try modelContext.fetch(descriptor)
      },
      addCategory: { category in
        modelContext.insert(category)
        try modelContext.save()
      },
      addLink: { link in
        modelContext.insert(link)
        try modelContext.save()
      },
      fetchLinkItem: {
        let descriptor = FetchDescriptor<LinkItem>()
        return try modelContext.fetch(descriptor)
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
