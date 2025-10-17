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
  }
  
  enum Action {
    case moreCategoryButtonTapped
    case categoryTapped(ArticleCategory)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .moreCategoryButtonTapped:
        return .none
        
      case let .categoryTapped(category):
        state.selectedCategory = category
        return .none
      }
    }
  }
}
