//
//  AddLinkFeature.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture
import Domain
import SwiftData

@Reducer
struct AddLinkFeature {
  
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable {
    var isConfirmAlertPresented = false
    var topAppBar = TopAppBarDefaultRightIconxFeature.State(title: AddLinkNamespace.naviTitle)
    var linkURL: String
    var categoryGrid = CategoryGridFeature.State(allowsMultipleSelection: false)
    var selectedCategory: CategoryItem?
    var isURLExisting: Bool = false
    var articles: [ArticleItem] = []
    //이삭 토스트 메시지
    var showToast: Bool = false
    var toastMessage: String = ""
    
    init(linkURL: String = "") {
      self.linkURL = linkURL
    }
  }
  
  enum Action {
    case backGestureSwiped
    case topAppBar(TopAppBarDefaultRightIconxFeature.Action)
    case setLinkURL(String)
    case saveButtonTapped
    case addNewCategoryButtonTapped
    case categoryGrid(CategoryGridFeature.Action)
    case confirmAlertDismissed
    case confirmAlertConfirmButtonTapped
    case saveLinkResponse(Result<Void, Error>)
    case checkURLExists(String)
    case didCheckURLExists(Bool)
    case showToast(String)
    case hideToast
    case fetch
    case fetchArticleItem
    case didFetchArticleItems(Result<ArticleItem?, Error>)
    case navigateToLinkDetail(ArticleItem)
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  var body: some ReducerOf<Self> {
    Scope(state: \.topAppBar, action: \.topAppBar) {
      TopAppBarDefaultRightIconxFeature()
    }
    
    Scope(state: \.categoryGrid, action: \.categoryGrid) {
      CategoryGridFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .backGestureSwiped, .topAppBar(.tapBackButton):
        if state.linkURL.isEmpty {
          return .run { _ in await linkNavigator.pop() }
        }
        state.isConfirmAlertPresented = true
        return .none
      
      case .topAppBar:
        return .none
        
      case let .didFetchArticleItems(.success(articles)):
        linkNavigator.push(.linkDetail, articles)
        return .none
        
      case let .didFetchArticleItems(.failure(error)):
        state.toastMessage = "링크 불러오기 실패"
        state.showToast = true
        return .run { send in
          try await Task.sleep(nanoseconds: 2_000_000_000)
          await send(.hideToast)
        }
        
      case .fetchArticleItem:
        guard let found = state.articles.first(where: { $0.urlString == state.linkURL }) else {
          state.toastMessage = "해당 링크를 찾을 수 없습니다"
          state.showToast = true
          return .run { send in
            try await Task.sleep(nanoseconds: 2_000_000_000)
            await send(.hideToast)
          }
        }
        return .send(.navigateToLinkDetail(found))

      case let .setLinkURL(url):
        state.linkURL = url
        return .send(.checkURLExists(url))
        
      case .saveButtonTapped:
        guard
          let url = URL(string: state.linkURL)
        else {
          //TODO: 에러 처리하기..
          return .none
        }
        
        return .run { [linkURL = state.linkURL, selectedCategory = state.selectedCategory] send in
          do {
            let title = try await extractTitle(from: url)
            let image = try await extractImageURL(from: url)
            let newLink = ArticleItem(urlString: linkURL, title: title, imageURL: image.absoluteString)
            newLink.category = selectedCategory
            try swiftDataClient.addLink(newLink)
            await send(.saveLinkResponse(.success(())))
          } catch {
            await send(.saveLinkResponse(.failure(error)))
          }
        }
        
      case .navigateToLinkDetail(let article):
        linkNavigator.push(.linkDetail, article)
        return .none
        
      case .addNewCategoryButtonTapped:
        linkNavigator.push(.addCategory, nil)
        return .none
        
      case .categoryGrid(.delegate(.toggleCategorySelection(let category))):
        if state.selectedCategory == category {
          state.selectedCategory = nil
        } else {
          state.selectedCategory = category
        }
        return .none
        
      case .categoryGrid:
        return .none
        
      case .confirmAlertDismissed:
        state.isConfirmAlertPresented = false
        return .none
        
      case .confirmAlertConfirmButtonTapped:
        state.isConfirmAlertPresented = false
        return .run { _ in await linkNavigator.pop() }
        
      case .saveLinkResponse(.success):
        return .run { _ in await linkNavigator.pop() }
        
      case .saveLinkResponse(.failure(let error)):
        //TODO: 링크 저장 실패시 에러 알럿?
        print("\(error)")
        return .none
        
      case let .checkURLExists(urlString):
        return .run { send in
          do {
            let exists = try await swiftDataClient.urlExists(urlString)
            await send(.didCheckURLExists(exists))
          } catch {
            await send(.didCheckURLExists(false))
          }
        }
        
      case let .didCheckURLExists(exists):
        state.isURLExisting = exists
        if exists {
          state.toastMessage = "이미 저장된 링크입니다"
          state.showToast = true
          return .run { send in
            try await Task.sleep(nanoseconds: 2_000_000_000)
            await send(.hideToast)
          }
        }
        return .none
        
      case .showToast(let message):
        state.toastMessage = message
        state.showToast = true
        return .run { send in
          try await Task.sleep(nanoseconds: 2_000_000_000)
          await send(.hideToast)
        }
      case .hideToast:
        state.showToast = false
        return .none
      case .fetch:
        return .none
      case .didFetchArticleItems(.failure(_)):
        return .none
      }
    }
  }
  
  //TODO: 함수들 어떻게 해야할지 생각해봐야함 SideEffect?
  private func extractTitle(from url: URL) async throws -> String {
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let htmlString = String(data: data, encoding: .utf8) else {
      throw URLError(.cannotDecodeContentData)
    }
    
    let regex = try NSRegularExpression(pattern: "<title[^>]*>(.*?)</title>", options: [.caseInsensitive, .dotMatchesLineSeparators])
    if let match = regex.firstMatch(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count)) {
      if let titleRange = Range(match.range(at: 1), in: htmlString) {
        let title = String(htmlString[titleRange]).trimmingCharacters(in: .whitespacesAndNewlines)
        return title.decodeHtmlEntities()
      }
    }
    throw URLError(.cannotParseResponse)
  }
}

private func extractImageURL(from url: URL) async throws -> URL {
  let (data, _) = try await URLSession.shared.data(from: url)
  guard let htmlString = String(data: data, encoding: .utf8) else {
    throw URLError(.cannotDecodeContentData)
  }
  
  let ogImageRegex = try NSRegularExpression(
    pattern: "<meta[^>]*property=[\"']og:image[\"'][^>]*content=[\"']([^\"']+)[\"'][^>]*>",
    options: [.caseInsensitive, .dotMatchesLineSeparators]
  )
  if let match = ogImageRegex.firstMatch(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count)),
     let range = Range(match.range(at: 1), in: htmlString) {
    let imageUrlString = String(htmlString[range])
    if let imageUrl = URL(string: imageUrlString, relativeTo: url) {
      return imageUrl
    }
  }
  
  let imgRegex = try NSRegularExpression(
    pattern: "<img[^>]*src=[\"']([^\"']+)[\"'][^>]*>",
    options: [.caseInsensitive, .dotMatchesLineSeparators]
  )
  if let match = imgRegex.firstMatch(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count)),
     let range = Range(match.range(at: 1), in: htmlString) {
    let imageUrlString = String(htmlString[range])
    if let imageUrl = URL(string: imageUrlString, relativeTo: url) {
      return imageUrl
    }
  }
  
  throw URLError(.fileDoesNotExist)
}

extension SwiftDataClient {
  @MainActor
  func urlExists(_ urlString: String) throws -> Bool {
    let container = AppGroupContainer.shared
    let context = container.mainContext
    let fetchDescriptor = FetchDescriptor<ArticleItem>(
      predicate: #Predicate { $0.urlString == urlString }
    )
    return try context.fetch(fetchDescriptor).first != nil
  }
}
