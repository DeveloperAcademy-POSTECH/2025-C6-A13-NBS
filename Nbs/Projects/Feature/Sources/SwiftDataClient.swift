
import Foundation
import SwiftData
import ComposableArchitecture

import Domain

struct SwiftDataClient {
  var fetchCategories: () throws -> [CategoryItem]
  var addCategory: (CategoryItem) throws -> Void
  var addLink: (LinkItem) throws -> Void
}

extension SwiftDataClient: DependencyKey {
  static let liveValue: Self = {
    guard let modelContainer = AppGroupContainer.createShareModelContainer() else {
      fatalError("ModelContainer 생성 실패")
    }
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
