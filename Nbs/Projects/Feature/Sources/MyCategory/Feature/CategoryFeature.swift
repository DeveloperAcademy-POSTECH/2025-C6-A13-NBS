//
//  CategoryFeature.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import ComposableArchitecture

@Reducer
struct CategoryListFeature {
  @ObservableState
  struct State: Equatable {
    var categories: [ArticleCategory] = ArticleCategory.mock
    var selectedCategory: ArticleCategory? = ArticleCategory.mock.first
    var isShowingEmptyView: Bool = false
    var addLinkView: Bool = false
  }
  
  enum Action {
    case moreCategoryButtonTapped
    case categoryTapped(ArticleCategory)
    case delegate(Delegate)
    
    enum Delegate {
      case goToMoreLinkButtonView
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .moreCategoryButtonTapped:
        state.isShowingEmptyView = true
        return .none
        
      case let .categoryTapped(category):
        state.selectedCategory = category
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}
