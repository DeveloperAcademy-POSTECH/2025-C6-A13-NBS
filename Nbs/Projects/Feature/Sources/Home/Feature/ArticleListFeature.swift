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
  
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State {
    var articles: [ArticleItem] = []
    var showMoreLink: Bool = false
    var showLinkDetail: Bool = false
    var showTipCard: Bool = true
  }
  
  enum Action {
    case moreLinkButtonTapped
    case listCellTapped(ArticleItem)
    case toggleTipCard
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .moreLinkButtonTapped:
        return .run { _ in
          linkNavigator.push(.linkList, nil)
        }
        
      case .listCellTapped(let article):
        linkNavigator.push(.linkDetail, article)
        return .none
        
      case .toggleTipCard:
        state.showTipCard = false
        return .none
      }
    }
  }
}
