
import Foundation
import SwiftData
import ComposableArchitecture

import Domain

struct SwiftDataClient {
  // LinkItem
  var fetchLinks: () throws -> [ArticleItem]
  var searchLinks: (String) throws -> [ArticleItem]
  var addLink: (ArticleItem) throws -> Void
  var updateLinkLastViewed: (ArticleItem) throws -> Void
  var fetchRecentLinks: () throws -> [ArticleItem]
  
  // CategoryItem
  var fetchCategories: () throws -> [CategoryItem]
  var addCategory: (CategoryItem) throws -> Void
  var updateCategory: (CategoryItem) throws -> Void
  var deleteCategory: (CategoryItem) throws -> Void
//  var addLink: (LinkItem) throws -> Void
}

extension SwiftDataClient: DependencyKey {
  static let liveValue: Self = {
    let modelContainer = AppGroupContainer.shared
    let modelContext = ModelContext(modelContainer)
    
    return Self(
      fetchLinks: {
        let descriptor = FetchDescriptor<ArticleItem>()
        return try modelContext.fetch(descriptor)
      },
      searchLinks: { query in
        let predicate = #Predicate<ArticleItem> {
          $0.title.contains(query)
        }
        let descriptor = FetchDescriptor<ArticleItem>(predicate: predicate)
        return try modelContext.fetch(descriptor)
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
        var descriptor = FetchDescriptor<ArticleItem>(
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
      },
      updateCategory: { category in
        try modelContext.save()
      },
      deleteCategory: { category in
        modelContext.delete(category)
        try modelContext.save()
      },
    )
  }()
}

extension DependencyValues {
  var swiftDataClient: SwiftDataClient {
    get { self[SwiftDataClient.self] }
    set { self[SwiftDataClient.self] = newValue }
  }
}
