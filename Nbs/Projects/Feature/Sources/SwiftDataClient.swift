
import Foundation
import SwiftData
import ComposableArchitecture

import Domain

struct SwiftDataClient {
  // LinkItem
  var fetchLinks: () throws -> [LinkItem]
  var searchLinks: (String) throws -> [LinkItem]
  var addLink: (LinkItem) throws -> Void
  var updateLinkLastViewed: (LinkItem) throws -> Void
  var fetchRecentLinks: () throws -> [LinkItem]
  
  // CategoryItem
  var fetchCategories: () throws -> [CategoryItem]
  var addCategory: (CategoryItem) throws -> Void
  var updateCategory: (CategoryItem) throws -> Void
  var deleteCategory: (CategoryItem) throws -> Void
  var addLink: (LinkItem) throws -> Void
  var fetchLinkItem: () throws -> [LinkItem]
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
      updateCategory: { category in
        try modelContext.save()
      },
      deleteCategory: { category in
        modelContext.delete(category)
        try modelContext.save()
      },
      addLink: { link in
        modelContext.insert(link)
        try modelContext.save()
      },
      updateLinkLastViewed: { link in
        link.lastViewedDate = Date()
        try modelContext.save()
      },
      fetchRecentLinks: {
        var descriptor = FetchDescriptor<LinkItem>(
          sortBy: [SortDescriptor(\.lastViewedDate, order: .reverse)]
        )
        descriptor.fetchLimit = 6
        return try modelContext.fetch(descriptor)
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
