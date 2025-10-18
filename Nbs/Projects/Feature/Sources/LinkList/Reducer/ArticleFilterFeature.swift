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
    var showMoreLink: Bool = false
    var showLinkDetail: Bool = false
    var sortOrder: SortOrder = .latest
  }
  
  enum SortOrder: Equatable {
      case latest
      case oldest
    }
  
  enum Action {
    case listCellTapped
    case sortOrderChanged(SortOrder)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .sortOrderChanged(order):
        state.sortOrder = order
        
        switch order {
        case .latest:
          state.articles.sort { $0.createAt > $1.createAt }
        case .oldest:
          state.articles.sort { $0.createAt < $1.createAt }
        }
        return .none
        
      case .listCellTapped:
        // TODO: 상세화면 네비게이션 로직 추가 예정
        return .none
      }
    }
  }
}
