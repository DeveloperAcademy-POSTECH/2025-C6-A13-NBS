//
//  HomeFeature.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import SwiftUI

import ComposableArchitecture
import Domain
import LinkNavigator

@Reducer
struct HomeFeature {
  
  @Dependency(\.clipboard) var clipboard
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State {
    var articleList = ArticleListFeature.State()
    var categoryList = CategoryListFeature.State()
    var alertBanner: AlertBannerState?
    var path = StackState<Path.State>()
    var copiedLink: String?
    var myCategoryCollection = MyCategoryCollectionFeature.State()
    var lastShownClipboardLink: String?
    
    struct AlertBannerState: Equatable {
      let text: String
      let message: String
    }
  }
  
  enum Action {
    case onAppear
    case clipboardResponded(String?)
    case dismissAlertBanner
    case articleList(ArticleListFeature.Action)
    case categoryList(CategoryListFeature.Action)
    case path(StackAction<Path.State, Path.Action>)
    case floatingButtonTapped
    case alertBannerTapped
    case fetchArticles
    case myCategoryCollection(MyCategoryCollectionFeature.Action)
    case articlesResponse(TaskResult<[ArticleItem]>)
    case searchButtonTapped
    case editCategory(EditCategoryFeature.Action)
    case editCategoryIconName(EditCategoryIconNameFeature.Action)
    case refresh
  }
  
  @Reducer
  enum Path {
    case linkList(LinkListFeature)
    case linkDetail(LinkDetailFeature)
    case myCategoryCollection(MyCategoryCollectionFeature)
    case addLink(AddLinkFeature)
    case addCategory(AddCategoryFeature)
    case search(SearchFeature)
    case editCategory(EditCategoryFeature)
    case deleteCategory(DeleteCategoryFeature)
    case editCategoryIconName(EditCategoryIconNameFeature)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.articleList, action: \.articleList) {
      ArticleListFeature()
    }
    
    Scope(state: \.categoryList, action: \.categoryList) {
      CategoryListFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(.clipboardResponded(clipboard.getString()))
          await send(.fetchArticles)
        }
        
      case .fetchArticles:
        return .run { send in
          await send(.articlesResponse(TaskResult { try swiftDataClient.fetchLinks() }))
        }
        
      case let .articlesResponse(.success(linkItems)):
        state.articleList.articles = linkItems
        return .none
        
      case .articlesResponse(.failure(let error)):
        print("Error fetching articles: \(error)")
        return .none
        
      case .refresh:
        return .run { send in
          await send(.fetchArticles)
        }
        
      case let .clipboardResponded(copiedText):
        guard let copiedText,
              let url = URL(string: copiedText),
              let _ = url.host else {
          return .none
        }
        
        guard state.lastShownClipboardLink != copiedText else {
          return .none
        }
        
        state.alertBanner = .init(
          text: "복사한 링크 바로 추가하기",
          message: copiedText
        )
        state.copiedLink = copiedText
        state.lastShownClipboardLink = copiedText
        return .none
        
      case .dismissAlertBanner:
        state.alertBanner = nil
        return .none
        
      case .floatingButtonTapped:
        return .run { _ in
          linkNavigator.push(.addLink, nil)
        }
        
      case .alertBannerTapped:
        if let link = state.copiedLink {
          //TODO: addLink로 이동
          linkNavigator.push(.addLink, link)
        }
        return .none
        
      case .searchButtonTapped:
        state.path.append(.search(SearchFeature.State()))
        return .none
        
      case .categoryList, .articleList, .path:
        return .none
      case .editCategory(_):
        return .none
      case .myCategoryCollection(_):
        return .none
      case .editCategoryIconName(_):
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

extension DependencyValues {
  var clipboard: ClipboardClient {
    get { self[ClipboardClient.self] }
    set { self[ClipboardClient.self] = newValue }
  }
}

struct ClipboardClient {
  var getString: () -> String?
}

extension ClipboardClient: DependencyKey {
  static let liveValue = Self(
    getString: { UIPasteboard.general.string }
  )
}
