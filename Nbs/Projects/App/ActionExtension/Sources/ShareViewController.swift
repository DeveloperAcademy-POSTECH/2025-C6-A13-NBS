//
//  ShareViewController.swift
//  ae
//
//  Created by 여성일 on 10/13/25.
//

import SwiftUI
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

import SwiftData

import DesignSystem
import Domain

// MARK: - ShareViewController
final class ShareViewController: UIViewController {
  private var hostingController: UIViewController?
  
  private var pageTitle: String = ""
  private var pageURL: String = ""
  private var draftHighlights: [[String: Any]]? = []
  private var currentLinkItem: ArticleItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureHostingController()
    extractAllData()
    addObservers()
  }
}

// MARK: - Configuration Method
private extension ShareViewController {
  func configureViewController() {
    view.backgroundColor = .clear
  }
  
  func configureHostingController() {
    let container = AppGroupContainer.shared
    
    let rootView = RootWrapperView(container: container) { [weak self] selectedCategory in
      guard let self = self else { return }
      if let category = selectedCategory {
        self.updateLinkItem(with: category)
      } else {
        self.closeExtension(clearDrafts: false)
      }
    }
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      let hostingController = UIHostingController(rootView: rootView)
      self.hostingController = hostingController
      
      guard let hostingController = self.hostingController else { return }
      hostingController.view.backgroundColor = .clear
      hostingController.view.isOpaque = false
      
      addChild(hostingController)
      view.addSubview(hostingController.view)
      
      hostingController.view.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
      ])
      
      hostingController.didMove(toParent: self)
    }
  }
}

// MARK: - Notification Method
private extension ShareViewController {
  func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(dismissKeyboard), name: .dismissKeyboard, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(closeExtensionSelector), name: .closeShareExtension, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleNewCategorySave), name: .newCategoryDidSave, object: nil)
  }
  
  @objc func dismissKeyboard() { view.endEditing(true) }
  @objc func closeExtensionSelector() { self.closeExtension(clearDrafts: true) }
  
  @objc func handleNewCategorySave(_ notification: Notification) {
    if let newCategory = notification.userInfo?["newCategory"] as? CategoryItem {
      self.updateLinkItem(with: newCategory)
    }
  }
}

// MARK: - ShareExtension Method
private extension ShareViewController {
  func extractAllData() {
    print("alldata")
    guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
          let attachments = extensionItem.attachments else {
      self.closeExtension(clearDrafts: false)
      return
    }
    
    print(extensionItem)
    
    let propertyListIdentifier = UTType.propertyList.identifier
    let urlIdentifier = UTType.url.identifier
    
    var propertyListFound = false
    
    for itemProvider in attachments {
      if itemProvider.hasItemConformingToTypeIdentifier(propertyListIdentifier) {
        propertyListFound = true
        itemProvider.loadItem(forTypeIdentifier: propertyListIdentifier, options: nil) { [weak self] (item, error) in
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
        break
      }
    }
    
    if !propertyListFound {
      for itemProvider in attachments {
        if itemProvider.hasItemConformingToTypeIdentifier(urlIdentifier) {
          itemProvider.loadItem(forTypeIdentifier: urlIdentifier, options: nil) { [weak self] (item, error) in
            guard let self = self, let url = item as? URL else {
              self?.closeExtension(clearDrafts: false)
              return
            }
            DispatchQueue.main.async {
              if self.pageURL.isEmpty {
                self.pageURL = url.absoluteString
                self.pageTitle = url.host ?? ""
                self.draftHighlights = []
                self.saveAllData()
              }
            }
          }
          break
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
private extension ShareViewController {
  func saveAllData() {
    print("saveAllData")
    guard !self.pageURL.isEmpty else {
      return
    }
    
    let container = AppGroupContainer.shared
    
    let context = container.mainContext
    let urlString = self.pageURL
    let fetchDescriptor = FetchDescriptor<ArticleItem>(predicate: #Predicate { $0.urlString == urlString })
    
    let linkItem: ArticleItem
    if let existingLink = try? context.fetch(fetchDescriptor).first {
      linkItem = existingLink
    } else {
      linkItem = ArticleItem(urlString: self.pageURL, title: self.pageTitle)
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
    } catch {
      self.closeExtension(clearDrafts: false)
    }
  }
  
  func updateLinkItem(with category: CategoryItem) {
    guard let linkItem = self.currentLinkItem else {
      self.closeExtension(clearDrafts: false)
      return
    }
    
    let container = AppGroupContainer.shared
    
    let context = container.mainContext
    linkItem.category = category
    
    do {
      try context.save()
      self.closeExtension(clearDrafts: true)
    } catch {
      self.closeExtension(clearDrafts: false)
    }
  }
}

fileprivate extension Notification.Name {
  static let dismissKeyboard = Notification.Name("dismissKeyboardNotification")
  static let newCategoryDidSave = Notification.Name("newCategoryDidSave")
  static let closeShareExtension = Notification.Name("closeShareExtension")
}
