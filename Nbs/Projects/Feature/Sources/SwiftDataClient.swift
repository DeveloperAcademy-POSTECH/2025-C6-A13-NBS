
import Foundation
import SwiftData
import ComposableArchitecture

import Domain

struct SwiftDataClient {
  // LinkItem
  var fetchLinks: () throws -> [ArticleItem]
  var fetchLink: (String) throws -> ArticleItem?
  var searchLinks: (String) throws -> [ArticleItem]
  var addLink: (ArticleItem) throws -> Void
  var updateLinkLastViewed: (ArticleItem) throws -> Void
  var fetchRecentLinks: () throws -> [ArticleItem]
  var deleteLink: (ArticleItem) throws -> Void
  var deleteLinks: ([ArticleItem]) throws -> Void
  var moveLinks: (_ links: [ArticleItem], _ category: CategoryItem?) throws -> Void
  var editLinkTitle: (_ id: String, _ newTitle: String) throws -> Void
  var updateLinkMemo: (_ id: String, _ memo: String) throws -> Void
  var deleteLinkById: (_ id: String) throws -> Void
  
  // CategoryItem
  var fetchCategories: () throws -> [CategoryItem]
  var addCategory: (CategoryItem) throws -> Void
  var updateCategory: (CategoryItem) throws -> Void
  var updateCategoryItem: (UUID, String, CategoryIcon) throws -> Void
  var deleteCategory: (CategoryItem) throws -> Void
  //  var addLink: (LinkItem) throws -> Void
  
  // WebView
  var updateHighlightsForLink: (_ linkID: String, _ highlights: [HighlightItem]) throws -> Void
  
  // Comment
  var addComment: (_ comment: Comment, _ highlightId: String) throws -> Void
  var deleteComment: (_ commentId: Double, _ highlightId: String) throws -> Void
  var editComment: (_ commentId: Double, _ newText: String, _ highlightId: String) throws -> Void
  
  // Highlight
  var deleteHighlight: (_ id: String) throws -> Void
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
      fetchLink: { id in
        let descriptor = FetchDescriptor<ArticleItem>(predicate: #Predicate { $0.id == id })
        return try modelContext.fetch(descriptor).first
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
      deleteLink: { link in
        modelContext.delete(link)
        try modelContext.save()
      },
      deleteLinks: { links in
        links.forEach { modelContext.delete($0) }
        try modelContext.save()
      },
      moveLinks: { links, category in
        links.forEach { $0.category = category }
        try modelContext.save()
      },
      editLinkTitle: { id, newTitle in
        let descriptor = FetchDescriptor<ArticleItem>(
          predicate: #Predicate { $0.id == id }
        )
        if let article = try modelContext.fetch(descriptor).first {
          article.title = newTitle
          try modelContext.save()
        }
      },
      updateLinkMemo: { id, memo in
        let descriptor = FetchDescriptor<ArticleItem>(
          predicate: #Predicate { $0.id == id }
        )
        guard let target = try modelContext.fetch(descriptor).first else {
          throw NSError(domain: "SwiftDataClient", code: 404, userInfo: [NSLocalizedDescriptionKey: "ArticleItem not found"])
        }
        target.userMemo = memo
        try modelContext.save()
      },
      deleteLinkById: { id in                     
        let descriptor = FetchDescriptor<ArticleItem>(
          predicate: #Predicate { $0.id == id }
        )
        if let target = try modelContext.fetch(descriptor).first {
          modelContext.delete(target)
          try modelContext.save()
        }
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
      updateCategoryItem: { id, name, icon in
        let descriptor = FetchDescriptor<CategoryItem>(predicate: #Predicate { $0.id == id })
        if let categoryToUpdate = try modelContext.fetch(descriptor).first {
          categoryToUpdate.categoryName = name
          categoryToUpdate.icon = icon
          try modelContext.save()
        }
      },
      deleteCategory: { category in
        modelContext.delete(category)
        try modelContext.save()
      },
      updateHighlightsForLink: { linkID, highlights in
        let descriptor = FetchDescriptor<ArticleItem>(predicate: #Predicate { $0.id == linkID })
        if let articleToUpdate = try modelContext.fetch(descriptor).first {
          articleToUpdate.highlights.forEach { modelContext.delete($0) }
          articleToUpdate.highlights = highlights
          try modelContext.save()
        }
      },
      addComment: { comment, highlightId in
        let descriptor = FetchDescriptor<HighlightItem>(predicate: #Predicate { $0.id == highlightId })
        guard let highlightToUpdate = try modelContext.fetch(descriptor).first else {
          return
        }
        
        highlightToUpdate.comments.append(comment)
        try modelContext.save()
      },
      deleteComment: { commentId, highlightId in
        let descriptor = FetchDescriptor<HighlightItem>(predicate: #Predicate { $0.id == highlightId})
        guard let highlightToUpdate = try modelContext.fetch(descriptor).first else {
          return
        }
        
        highlightToUpdate.comments.removeAll { $0.id == commentId }
        
        try modelContext.save()
      },
      editComment: { commentId, newText, highlightId in
        let descriptor = FetchDescriptor<HighlightItem>(predicate: #Predicate { $0.id == highlightId})
        guard let highlightToUpdate = try modelContext.fetch(descriptor).first else {
          return
        }
        
        guard let index = highlightToUpdate.comments.firstIndex(where: { $0.id == commentId}) else {
          return
        }
        
        var commentToEdit = highlightToUpdate.comments[index]
        let updatedCommet = Comment(id: commentToEdit.id, type: commentToEdit.type, text: newText)
        highlightToUpdate.comments[index] = updatedCommet
        
        try modelContext.save()
      },
      deleteHighlight: { id in
        let descriptor = FetchDescriptor<HighlightItem>(predicate: #Predicate { $0.id == id})
        if let target = try modelContext.fetch(descriptor).first {
          modelContext.delete(target)
          try modelContext.save()
        }
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
