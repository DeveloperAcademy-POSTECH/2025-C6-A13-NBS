//
//  SafariWebExtensionHandler.swift
//  aa Extension
//
//  Created by Hong on 9/30/25.
//

import SwiftData
import SafariServices
import Domain

final class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
  func beginRequest(with context: NSExtensionContext) {
    guard let item = context.inputItems.first as? NSExtensionItem,
          let userInfo = item.userInfo,
          let message = userInfo[SFExtensionMessageKey] as? [String: Any],
          let action = message["action"] as? String else {
      context.completeRequest(returningItems: nil, completionHandler: nil)
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

// MARK: - Communication Method
private extension SafariWebExtensionHandler {
  func fetchHighlights(for urlString: String) -> [[String: Any]] {
    guard let container = AppGroupContainer.createShareModelContainer() else {
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
