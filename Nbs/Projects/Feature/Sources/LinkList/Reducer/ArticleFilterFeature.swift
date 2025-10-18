//
//  ArticleFilterFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import ComposableArchitecture

@Reducer
struct ArticleFilterFeature {
  @ObservableState
  struct State {
    var articles: [MockArticle] = MockArticle.mockArticles
    var sortOrder: SortOrder = .latest
    var selectedArticle: MockArticle? = nil
  }
  
  enum SortOrder: Equatable {
    case latest
    case oldest
  }
  
  enum Action {
    case listCellTapped(MockArticle)
    case sortOrderChanged(SortOrder)
    case delegate(Delegate)
    enum Delegate {
      case openLinkDetail(MockArticle)
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .listCellTapped(article):
        return .send(.delegate(.openLinkDetail(article)))
        
      case let .sortOrderChanged(order):
        state.sortOrder = order
        
        switch order {
        case .latest:
          state.articles.sort { $0.createAt > $1.createAt }
        case .oldest:
          state.articles.sort { $0.createAt < $1.createAt }
        }
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}
