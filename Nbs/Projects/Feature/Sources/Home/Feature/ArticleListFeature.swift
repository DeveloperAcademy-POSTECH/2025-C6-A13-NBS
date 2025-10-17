//
//  ArticleListFeature.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import ComposableArchitecture

@Reducer
struct ArticleListFeature {
  @ObservableState
  struct State {
    let articles: [MockArticle] = MockArticle.mockArticles
    var showMoreLink: Bool = false
    var showLinkDetail: Bool = false
  }
  
  enum Action {
    case moreLinkButtonTapped
    case listCellTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .moreLinkButtonTapped:
        state.showMoreLink = true
        return .none
        
      case .listCellTapped:
        state.showLinkDetail = true
        return .none
      }
    }
  }
}
