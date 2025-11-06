//
//  MyCategoryCollectionFeature.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct MyCategoryCollectionFeature {
  
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable {
    var topAppBar = TopAppBarDefaultNoSearchFeature.State(title: CategoryNamespace.myCategoryCollection)
    var categoryGrid = CategoryGridFeature.State()
    var selectedCategory: CategoryItem?
    var settingModal: CategorySettingFeature.State?
    var myCategoryGrid = MyCategoryGridFeature.State()
    var allLinksCount = 0
  }
  
  enum Action {
    case topAppBar(TopAppBarDefaultNoSearchFeature.Action)
    case categoryGrid(CategoryGridFeature.Action)
    case settingModal(CategorySettingFeature.Action)
    case totalLinkTapped
    case myCategoryGrid(MyCategoryGridFeature.Action)
    case fetchArticleResponse(Result<[ArticleItem], Error>)
    case onAppear
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  var body: some ReducerOf<Self> {
    Scope(state: \.topAppBar, action: \.topAppBar) {
      TopAppBarDefaultNoSearchFeature()
    }
    
    Scope(state: \.categoryGrid, action: \.categoryGrid) {
      CategoryGridFeature()
    }
    
    Scope(state: \.myCategoryGrid, action: \.myCategoryGrid) {
         MyCategoryGridFeature()
       }
    Reduce { state, action in
      switch action {
      case .totalLinkTapped:
        linkNavigator.push(.linkList, nil)
        return .none
      case .topAppBar(.tapBackButton):
        return .run { _ in await linkNavigator.pop() }
      case .topAppBar(.tapSettingButton):
        state.settingModal = CategorySettingFeature.State()
        return .none
      case .categoryGrid(_):
        return .none
      case .onAppear:
        return .run { send in
          await send(.fetchArticleResponse(Result {
            try swiftDataClient.fetchLinks()
          }))
        }
      case .settingModal(.dismissButtonTapped):
        state.settingModal = nil
        return .none
      case .settingModal(.addButtonTapped):
        linkNavigator.push(.addCategory, nil)
        return .none
      case .settingModal(.editButtonTapped):
        linkNavigator.push(.editCategory, nil)
        return .none
      case .settingModal(.deleteButtonTapped):
        linkNavigator.push(.deleteCategory, nil)
        return .none
      case .myCategoryGrid(_):
        return .none
      case let .fetchArticleResponse(.success(article)):
        state.allLinksCount = article.count
        return .none
      case .fetchArticleResponse(.failure(_)):
        return .none
      }
    }
  }
}
