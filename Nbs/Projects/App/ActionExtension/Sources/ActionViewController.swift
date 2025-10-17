//
//  ActionViewController.swift
//  ae
//
//  Created by 여성일 on 10/13/25.
//

import SwiftUI
import UIKit

import SwiftData
import MobileCoreServices
import UniformTypeIdentifiers

import Domain

final class ActionViewController: UIViewController {
  private var hostingController: UIHostingController<ActionBottomSheet>?
  
  private var pageTitle: String = ""
  private var pageURL: String = ""
  private var draftHighlights: [[String: Any]]? = []
  private var currentLinkItem: LinkItem?
  
  private var bottomSheetView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureHostingController()
    extractAllData()
  }
}

// MARK: - Configuration Method
private extension ActionViewController {
  func configureViewController() {
    view.backgroundColor = .clear
  }
  
  func configureHostingController() {
    let rootView = ActionBottomSheet(saveAction: {})
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      let hostingController = UIHostingController(rootView: rootView)
      self.hostingController = hostingController
      
      guard let hostingController = self.hostingController else { return }
      hostingController.view.backgroundColor = .white
      hostingController.view.layer.cornerRadius = 16
      
      addChild(hostingController)
      view.addSubview(hostingController.view)
      
      hostingController.view.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        hostingController.view.heightAnchor.constraint(equalToConstant: 300),
        //hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
      ])
      
      hostingController.didMove(toParent: self)
    }
  }
}

// MARK: - ActionExtension Method
private extension ActionViewController {
  func extractAllData() {
    print("alldata")
    guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
          let itemProvider = extensionItem.attachments?.first else {
      return
    }
    
    print(extensionItem)
    
    let propertyList = UTType.propertyList.identifier
    if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
      itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil) { [weak self] (item, error) in
        DispatchQueue.main.async {
          guard let self = self,
                let dictionary = item as? [String: Any],
                let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? [String: Any] else {
            return
          }
          
          if let title = results["title"] as? String, let url = results["url"] as? String {
            self.pageTitle = title
            self.pageURL = url
          }
          
          if let drafts = results["drafts"] as? [[String: Any]] {
            self.draftHighlights = drafts
          }
          self.saveAllData()
        }
      }
    }
  }
  
  private func closeExtension(clearDrafts: Bool) {
    let extensionItem = NSExtensionItem()
    if clearDrafts {
      let arguments = ["clearDrafts": true]
      extensionItem.attachments = [NSItemProvider(item: arguments as NSSecureCoding, typeIdentifier: UTType.propertyList.identifier)]
    }
    self.extensionContext?.completeRequest(returningItems: [extensionItem], completionHandler: nil)
  }
}

// MARK: - SwiftData
private extension ActionViewController {
  static func createShareModelContainer() -> ModelContainer? {
    let appGroupID = "group.com.nbs.dev.ADA.shared"
    let schema = Schema([LinkItem.self, HighlightItem.self, Category.self])
    
    guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
      return nil
    }
    
    let storeURL = containerURL.appendingPathComponent("Nbs_store.sqlite") // 사파리 익스텐션과 앱이 하나의 단일 DB를 사용하기 위해 storeURL 지정
    let configuration = ModelConfiguration(schema: schema, url: storeURL)
    
    do {
      return try ModelContainer(for: schema, configurations: [configuration])
    } catch {
      return nil
    }
  }
  
  func saveAllData() {
    print("saveAllData")
    guard !self.pageURL.isEmpty,
          let container = ActionViewController.createShareModelContainer() else {
      return
    }
    
    let context = container.mainContext
    let urlString = self.pageURL
    let fetchDescriptor = FetchDescriptor<LinkItem>(predicate: #Predicate { $0.urlString == urlString})
    
    let linkItem: LinkItem
    if let existingLink = try? context.fetch(fetchDescriptor).first {
      linkItem = existingLink
    } else {
      linkItem = LinkItem(urlString: self.pageURL, title: self.pageTitle)
      context.insert(linkItem)
    }
    self.currentLinkItem = linkItem
    
    if let drafts = self.draftHighlights, !drafts.isEmpty {
      for draft in drafts {
        guard let id = draft["id"] as? String,
              let sentence = draft["sentence"] as? String,
              let type = draft["type"] as? String,
              let commentsArray = draft["comments"] as? [[String: Any]] else { continue }
        
        let comments = commentsArray.compactMap { commentDict -> Comment? in
          guard let commentId = commentDict["id"] as? Double,
                let commentText = commentDict["text"] as? String,
                let commentType = commentDict["type"] as? String else { return nil }
          return Comment(id: commentId, type: commentType, text: commentText)
        }
        
        let highlightId = id
        let highlightFetch = FetchDescriptor<HighlightItem>(predicate: #Predicate { $0.id == highlightId })
        if let existingHighlight = try? context.fetch(highlightFetch).first {
          existingHighlight.sentence = sentence
          existingHighlight.type = type
          existingHighlight.comments = comments
        } else {
          let newHighlight = HighlightItem(id: id, sentence: sentence, type: type, createdAt: Date(), comments: comments)
          newHighlight.link = linkItem
          context.insert(newHighlight)
        }
      }
    }
    
    do {
      try context.save()
      //self.closeExtension(clearDrafts: true)
    } catch {
      self.closeExtension(clearDrafts: false)
    }
  }
}
