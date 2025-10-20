//
//  SearchFeature.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchFeature {
  @ObservableState
  struct State: Equatable {
    var topAppBar: TopAppBarSearchFeature.State = .init()
    var recentSearch: RecentSearchFeature.State = .init()
  }
  
  enum Action: Equatable {
    case onAppear
    case backgroundTapped
    case topAppBar(TopAppBarSearchFeature.Action)
    case recentSearch(RecentSearchFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.topAppBar, action: \.topAppBar) {
      TopAppBarSearchFeature()
    }
    Scope(state: \.recentSearch, action: \.recentSearch) {
      RecentSearchFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.topAppBar(.setSearchFieldFocus(true)))
        
      case .backgroundTapped:
        return .send(.topAppBar(.setSearchFieldFocus(false)))
      
      case .topAppBar(.delegate(let action)):
        switch action {
        case .searchTriggered(let query):
          return .send(.recentSearch(.add(query)))
        }
        
      case .recentSearch(.delegate(let action)):
        switch action {
        case .chipTapped(let term):
          return .send(.topAppBar(.setSearchText(term)))
        }
        
      case .topAppBar, .recentSearch:
        return .none
      }
    }
  }
}
