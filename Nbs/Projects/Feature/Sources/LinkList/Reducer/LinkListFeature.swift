//
//  LinkListFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct LinkListFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State {
    var categoryChipList = CategoryChipFeature.State()
    var articleList = ArticleFilterFeature.State()
    var allLinks: [LinkItem] = []
    var showBottomSheet: Bool = false
    var selectedCategory: CategoryItem? = nil
  }
  
  enum Action {
    case onAppear
    case categoryChipList(CategoryChipFeature.Action)
    case articleList(ArticleFilterFeature.Action)
    case bottomSheetButtonTapped(Bool)
    case fetchLinks
    case fetchLinksResponse(TaskResult<[LinkItem]>)
    case delegate(Delegate)
    enum Delegate {
      case openLinkDetail(LinkItem)
    }
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.categoryChipList, action: \.categoryChipList) {
      CategoryChipFeature()
    }
    
    Scope(state: \.articleList, action: \.articleList) {
      ArticleFilterFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(.fetchLinks)
        }
        
      case .fetchLinks:
        return .run { send in
          await send(.fetchLinksResponse(TaskResult {
            try swiftDataClient.fetchLinkItem()
          }))
        }
        
      case let .fetchLinksResponse(.success(items)):
        state.allLinks = items
        state.articleList.articles = items
        
        if let selected = state.selectedCategory {
          state.categoryChipList.selectedCategory = selected
          state.articleList.articles = items.filter {
            $0.category?.categoryName == selected.categoryName
          }
        }
        
        return .none
        
      case let .fetchLinksResponse(.failure(error)):
        print("LinkList fetch failed:", error)
        return .none
        
      case let .categoryChipList(.categoryTapped(category)):
        if category.categoryName == "전체" {
          state.articleList.articles = state.allLinks
        } else {
          state.articleList.articles = state.allLinks.filter {
            guard let itemCategory = $0.category else { return false }
            return itemCategory.categoryName == category.categoryName
          }
        }
        return .none
        
      case let .articleList(.delegate(.openLinkDetail(link))):
        return .send(.delegate(.openLinkDetail(link)))
        
      case .bottomSheetButtonTapped(let value):
        state.showBottomSheet = value
        return .none
        
      case .categoryChipList, .articleList:
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}
