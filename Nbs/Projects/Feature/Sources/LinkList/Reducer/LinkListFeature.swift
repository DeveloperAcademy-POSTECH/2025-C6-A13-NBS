//
//  LinkListFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import ComposableArchitecture

@Reducer
struct LinkListFeature {
  @ObservableState
  struct State {
    var categoryChipList = CategoryChipFeature.State()
    var articleList = ArticleFilterFeature.State()
    var showBottomSheet: Bool = false
  }
  
  enum Action {
    case categoryChipList(CategoryChipFeature.Action)
    case articleList(ArticleFilterFeature.Action)
    case bottomSheetButtonTapped(Bool)
    case delegate(Delegate)
    enum Delegate {
      case openLinkDetail(MockArticle)
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
      case .bottomSheetButtonTapped(let value):
        state.showBottomSheet = value
        return .none
        
      case let .articleList(.delegate(.openLinkDetail(article))):
        return .send(.delegate(.openLinkDetail(article)))
        
      case .categoryChipList, .articleList:
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}
