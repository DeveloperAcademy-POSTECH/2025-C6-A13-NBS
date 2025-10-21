//
//  HomeFeature.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import SwiftUI

import ComposableArchitecture
import Domain

@Reducer
struct HomeFeature {
  
  @Dependency(\.clipboard) var clipboard
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State {
    var articleList = ArticleListFeature.State()
    var categoryList = CategoryListFeature.State()
    var alertBanner: AlertBannerState?
    var path = StackState<Path.State>()
    var copiedLink: String?
    var myCategoryCollection = MyCategoryCollectionFeature.State()
    
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
    case articlesResponse(TaskResult<[LinkItem]>)
  }
  
  @Reducer
  enum Path {
    case linkList(LinkListFeature)
    case linkDetail(LinkDetailFeature)
    //    case categoryGridView(CategoryGridFeature)
    case myCategoryCollection(MyCategoryCollectionFeature)
    case addLink(AddLinkFeature)
    case addCategory(AddCategoryFeature)
    case editCategory(EditCategoryFeature)
    case deleteCategory(DeleteCategoryFeature)
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
          await send(.articlesResponse(TaskResult { try swiftDataClient.fetchLinkItem() }))
        }
        
      case let .articlesResponse(.success(linkItems)):
        state.articleList.articles = linkItems
        return .none
        
      case .articlesResponse(.failure(let error)):
        print("Error fetching articles: \(error)")
        return .none
        
      case let .clipboardResponded(copiedText):
        guard let copiedText,
              let url = URL(string: copiedText),
              let _ = url.host else {
          return .none
        }
        state.alertBanner = .init(
          text: "복사한 링크 바로 추가하기",
          message: copiedText
        )
        state.copiedLink = copiedText
        return .none
        
        /// 더보기 -> 링크 리스트
      case .articleList(.delegate(.openLinkList)):
        state.path.append(.linkList(LinkListFeature.State()))
        return .none
        
        /// 기사 탭 -> 링크 디테일
      case let .articleList(.delegate(.openLinkDetail(article))):
        state.path.append(.linkDetail(LinkDetailFeature.State(article: article)))
        return .none
        
        /// 링크 리스트 -> 내부 기사 클릭
      case let .path(.element(_, .linkList(.delegate(.openLinkDetail(article))))):
        state.path.append(.linkDetail(LinkDetailFeature.State(article: article)))
        return .none
        
      case .path(.element(_, .addLink(.delegate(.goToAddCategory)))):
        state.path.append(.addCategory(AddCategoryFeature.State()))
        return .none
        
      case .path(.element(_, .myCategoryCollection(.delegate(.addCategory)))):
        state.path.append(.addCategory(AddCategoryFeature.State()))
        return .none
        
      case .path(.element(_, .myCategoryCollection(.delegate(.editCategory)))):
        state.path.append(.editCategory(EditCategoryFeature.State()))
        return .none
        
      case .path(.element(_, .myCategoryCollection(.delegate(.deleteCategory)))):
        state.path.append(.addCategory(AddCategoryFeature.State()))
        return .none
        
      case .path(.element(_, .addLink(.delegate(.goToAddCategory)))):
        state.path.append(.addCategory(AddCategoryFeature.State()))
        return .none
        
      case .dismissAlertBanner:
        state.alertBanner = nil
        return .none
        
      case .categoryList(.delegate(.goToMoreLinkButtonView)):
        state.path.append(.myCategoryCollection(MyCategoryCollectionFeature.State()))
        return .none
        
      case .floatingButtonTapped:
        state.path.append(.addLink(AddLinkFeature.State()))
        return .none
        
      case .alertBannerTapped:
        if let link = state.copiedLink {
          state.path.append(.addLink(AddLinkFeature.State(linkURL: link)))
        }
        return .none
        
      case .articleList, .path:
        return .none
      case .categoryList(.onAppear):
        return .none
      case .categoryList(.categoriesResponse(_)):
        return .none
      case .categoryList(.moreCategoryButtonTapped):
        return .none
      case .categoryList(.categoryTapped(_)):
        return .none
      case .myCategoryCollection(_):
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
