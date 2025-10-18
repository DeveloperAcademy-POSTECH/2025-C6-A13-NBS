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
  }
  
  enum Action {
    case categoryChipList(CategoryChipFeature.Action)
    case articleList(ArticleFilterFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.categoryChipList, action: \.categoryChipList) {
      CategoryChipFeature()
    }
    
    Scope(state: \.articleList, action: \.articleList) {
      ArticleFilterFeature()
    }
  }
}
