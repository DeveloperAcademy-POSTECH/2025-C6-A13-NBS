//
//  SafariWebExtensionHandler.swift
//  C6_Safari Extension
//
//  Created by 여성일 on 10/7/25.
//

import SafariServices

import Domain

import SwiftData

final class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
  func beginRequest(with context: NSExtensionContext) {
    guard let item = context.inputItems.first as? NSExtensionItem else {
      context.completeRequest(returningItems: nil, completionHandler: nil)
      return
    }
    
    guard let userInfo = item.userInfo else {
      context.completeRequest(returningItems: nil, completionHandler: nil)
      return
    }
    
    guard let message = userInfo[SFExtensionMessageKey] as? [String: Any] else {
      context.completeRequest(returningItems: nil, completionHandler: nil)
      return
    }
    
    guard let action = message["action"] as? String else {
      self.sendResponse(to: context, with: ["error": "No action specified"])
      return
    }
    
    switch action {
    case "getLatestDataForURL":
      guard let url = message["url"] as? String else {
        self.sendResponse(to: context, with: ["error": "URL not provided"])
        return
      }
      
      let highlights = self.fetchHighlights(for: url)
      self.sendResponse(to: context, with: ["highlights": highlights])
      
    default:
      self.sendResponse(to: context, with: ["error": "Unknown action"])
    }
  }
}

// MARK: - SwiftData
private extension SafariWebExtensionHandler {
  static func createSharedModelContainer() -> ModelContainer? {
    let appGroupID = "group.com.nbs.dev.ADA.shared"
    let schema = Schema([LinkItem.self, HighlightItem.self, CategoryItem.self])
    
    guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
      return nil
    }
    
    let storeURL = containerURL.appendingPathComponent("C6_Safari.sqlite")
    let configuration = ModelConfiguration(schema: schema, url: storeURL)
    
    do {
      return try ModelContainer(for: schema, configurations: [configuration])
    } catch {
      return nil
    }
  }
}

// MARK: - Communication Method
private extension SafariWebExtensionHandler {
  func fetchHighlights(for urlString: String) -> [[String: Any]] {
    guard let container = SafariWebExtensionHandler.createSharedModelContainer() else {
      return []
    }
    
    let context = ModelContext(container)
    
    let fetchDescriptor = FetchDescriptor<LinkItem>(predicate: #Predicate { $0.urlString == urlString })
    
    guard let linkItem = try? context.fetch(fetchDescriptor).first else {
      return []
    }
    
    let highlights = linkItem.highlights
  
    let serializableHighlights: [[String: Any]] = highlights.map { highlight in
      let commentData = highlight.comments.map { comment in
        return ["id": comment.id, "text": comment.text, "type": comment.type]
      }
      return [
        "id": highlight.id,
        "sentence": highlight.sentence,
        "type": highlight.type,
        "createdAt": highlight.createdAt.timeIntervalSince1970,
        "comments": commentData
      ]
    }
    
    return serializableHighlights
  }
  
  func sendResponse(to context: NSExtensionContext, with message: [String: Any]) {
    let response = NSExtensionItem()
    response.userInfo = [SFExtensionMessageKey: message]
    context.completeRequest(returningItems: [response], completionHandler: nil)
  }
}
