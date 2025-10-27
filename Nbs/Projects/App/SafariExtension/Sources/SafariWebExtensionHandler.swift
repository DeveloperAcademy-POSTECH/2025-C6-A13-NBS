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
      
      if let highlights = self.fetchHighlights(for: url) {
          self.sendResponse(to: context, with: ["highlights": highlights])
      } else {
          self.sendResponse(to: context, with: ["highlights": []]) 
      }
      
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
    
    let storeURL = containerURL.appendingPathComponent("Nbs_store.sqlite")
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
  func fetchHighlights(for urlString: String) -> Any? {
    guard let container = SafariWebExtensionHandler.createSharedModelContainer() else {
      return nil
    }
    
    let context = ModelContext(container)
    
    let fetchDescriptor = FetchDescriptor<LinkItem>(predicate: #Predicate { $0.urlString == urlString })
    
    guard let linkItem = try? context.fetch(fetchDescriptor).first else {
      return nil
    }
    
    let highlights = linkItem.highlights
    
    do {
      let encoder = JSONEncoder()
      encoder.dateEncodingStrategy = .secondsSince1970
      let jsonData = try encoder.encode(highlights)
      let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
      return jsonObject
    } catch {
      print("하이라이트 인코딩 실패: \(error)")
      return nil
    }
  }
  
  func sendResponse(to context: NSExtensionContext, with message: [String: Any]) {
    let response = NSExtensionItem()
    response.userInfo = [SFExtensionMessageKey: message]
    context.completeRequest(returningItems: [response], completionHandler: nil)
  }
}


