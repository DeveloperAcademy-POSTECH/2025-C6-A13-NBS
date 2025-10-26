//
//  AddLinkFeature.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture
import Domain

@Reducer
struct AddLinkFeature {
  
  @Dependency(\.dismiss) var dismiss
  
  @ObservableState
  struct State: Equatable {
    var topAppBar = TopAppBarDefaultRightIconxFeature.State(title: AddLinkNamespace.naviTitle)
    var linkURL: String
    var categoryGrid = CategoryGridFeature.State(allowsMultipleSelection: false)
    var selectedCategory: CategoryItem?
    
    init(linkURL: String = "") {
      self.linkURL = linkURL
    }
  }
  
  enum Action {
    case topAppBar(TopAppBarDefaultRightIconxFeature.Action)
    case setLinkURL(String)
    case saveButtonTapped
    case addNewCategoryButtonTapped
    case categoryGrid(CategoryGridFeature.Action)
    case saveLinkResponse(TaskResult<Void>)
    case delegate(Delegate)
    
    enum Delegate {
      case goToAddCategory
    }
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
      case .topAppBar(.tapBackButton):
        return .run { _ in await self.dismiss() }
        
      case .topAppBar:
        return .none
        
      case let .setLinkURL(url):
        state.linkURL = url
        return .none
        
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
            let newLink = LinkItem(urlString: linkURL, title: title, imageURL: image.absoluteString)
            newLink.category = selectedCategory
            try swiftDataClient.addLink(newLink)
            await send(.saveLinkResponse(.success(())))
          } catch {
            await send(.saveLinkResponse(.failure(error)))
          }
        }
        
      case .addNewCategoryButtonTapped:
        return .send(.delegate(.goToAddCategory))
        
      case .categoryGrid(.delegate(.toggleCategorySelection(let category))):
        if state.selectedCategory == category {
          state.selectedCategory = nil
        } else {
          state.selectedCategory = category
        }
        return .none
        
      case .categoryGrid:
        return .none
        
      case .saveLinkResponse(.success):
        return .run { _ in await self.dismiss() }
        
      case .saveLinkResponse(.failure(let error)):
        //TODO: 링크 저장 실패시 에러 알럿?
        print("\(error)")
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
  
  private func extractTitle(from url: URL) async throws -> String {
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let htmlString = String(data: data, encoding: .utf8) else {
      throw URLError(.cannotDecodeContentData)
    }
    
    let regex = try NSRegularExpression(pattern: "<title[^>]*>(.*?)</title>", options: [.caseInsensitive, .dotMatchesLineSeparators])
    if let match = regex.firstMatch(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count)) {
      if let titleRange = Range(match.range(at: 1), in: htmlString) {
        let title = String(htmlString[titleRange]).trimmingCharacters(in: .whitespacesAndNewlines)
        return title
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
