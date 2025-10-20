//
//  ArticleListFeature.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct ArticleListFeature {
  @ObservableState
  struct State {
    var articles: [LinkItem] = []
    var showMoreLink: Bool = false
    var showLinkDetail: Bool = false
  }
  
  enum Action {
    case moreLinkButtonTapped
    case listCellTapped(MockArticle)
    case delegate(Delegate)
    
    enum Delegate {
      case openLinkDetail(MockArticle)
      case openLinkList
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .moreLinkButtonTapped:
        return .send(.delegate(.openLinkList))
        
      case let .listCellTapped(article):
        return .send(.delegate(.openLinkDetail(article)))
        
      case .delegate:
        return .none
      }
    }
  }
}
