//
//  SearchFeature.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import Foundation
import ComposableArchitecture

import Domain

@Reducer
struct SearchFeature {
  @ObservableState
  struct State: Equatable {
    var topAppBar: TopAppBarSearchFeature.State = .init()
    var recentSearch: RecentSearchFeature.State = .init()
    var recentLink: RecentLinkFeature.State = .init()
    var searchResult: SearchResultFeature.State = .init()
    var searchSuggestion: SearchSuggestionFeature.State = .init()
    var isSearchSubmitted: Bool = false
  }
  
  enum Action: Equatable {
    case onAppear
    case backgroundTapped
    case topAppBar(TopAppBarSearchFeature.Action)
    case recentSearch(RecentSearchFeature.Action)
    case recentLink(RecentLinkFeature.Action)
    case searchResult(SearchResultFeature.Action)
    case searchSuggestion(SearchSuggestionFeature.Action)
    
    case delegate(DelegateAction)
  }
  
  enum DelegateAction: Equatable {
    case openLinkDetail(LinkItem)
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some ReducerOf<Self> {
    Scope(state: \.topAppBar, action: \.topAppBar) {
      TopAppBarSearchFeature()
    }
    Scope(state: \.recentSearch, action: \.recentSearch) {
      RecentSearchFeature()
    }
    Scope(state: \.recentLink, action: \.recentLink) {
      RecentLinkFeature()
    }
    Scope(state: \.searchResult, action: \.searchResult) {
      SearchResultFeature()
    }
    Scope(state: \.searchSuggestion, action: \.searchSuggestion) {
      SearchSuggestionFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(.topAppBar(.setSearchFieldFocus(true)))
          await send(.recentSearch(.onAppear))
          await send(.recentLink(.onAppear))
        }
        
      case .backgroundTapped:
        return .send(.topAppBar(.setSearchFieldFocus(false)))
        
      case .topAppBar(.delegate(let action)):
        switch action {
        case .searchTriggered(let query):
          state.isSearchSubmitted = true
          return .run { send in
            await send(.recentSearch(.add(query)))
            await send(.searchResult(.loadSearchResult(query)))
          }
        case .searchQueryChanged(let query):
          state.isSearchSubmitted = false
          return .run { send in
            await send(.searchSuggestion(.loadSuggestionItem(query)))
          }
          .debounce(id: "search-debounce", for: 0.5, scheduler: RunLoop.main)
          .cancellable(id: "search-debounce", cancelInFlight: true)
        case .backButtonTapped:
          return .run { _ in
            await self.dismiss()
          }
        }

      case .recentSearch(.delegate(let action)):
        switch action {
        case .chipTapped(let term):
          state.isSearchSubmitted = true
          return .run { send in
            await send(.topAppBar(.setSearchText(term)))
            await send(.searchResult(.loadSearchResult(term)))
          }
        }
        
      case .searchResult(.delegate(let action)):
        switch action {
        case .openLinkDetail(let item):
          return .send(.delegate(.openLinkDetail(item)))
        }
      
      case .searchSuggestion(.delegate(let action)):
        switch action {
        case .openLinkDetail(let item):
          return .send(.delegate(.openLinkDetail(item)))
        }
        
      case .recentLink(.delegate(let action)):
        switch action {
        case .openLinkDetail(let item):
          return .send(.delegate(.openLinkDetail(item)))
        }
        
      case .topAppBar, .recentSearch, .recentLink, .searchResult, .searchSuggestion:
        return .none
      
      case .delegate:
        return .none
      }
    }
  }
}
