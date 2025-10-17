//
//  HomeFeature.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import ComposableArchitecture

@Reducer
struct HomeFeature {
  @ObservableState
  struct State {
    var articleList = ArticleListFeature.State()
    var categoryList = CategoryListFeature.State()
  }

  enum Action {
    case articleList(ArticleListFeature.Action)
    case categoryList(CategoryListFeature.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.articleList, action: \.articleList) {
      ArticleListFeature()
    }
    
    Scope(state: \.categoryList, action: \.categoryList) {
      CategoryListFeature()
    }
  }
}
