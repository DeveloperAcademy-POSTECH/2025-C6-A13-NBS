//
//  SearchSuggestionFeature.swift
//  Feature
//
//  Created by 여성일 on 10/21/25.
//

import ComposableArchitecture

import Domain

@Reducer
struct SearchSuggestionFeature {
  @ObservableState
  struct State: Equatable {
    var suggestionItem: [LinkItem] = []
  }
  
  enum Action: Equatable {
    case loadSuggestionItem(String)
    case suggestionResponse([LinkItem])
    case suggestionTapped(LinkItem)
    
    case delegate(DelegateAction)
  }
  
  enum DelegateAction: Equatable {
    case openLinkDetail(LinkItem)
  }

  @Dependency(\.swiftDataClient) var swiftDataClient
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .loadSuggestionItem(let query):
        guard !query.isEmpty else {
          state.suggestionItem = []
          return .none
        }
        return .run { send in
          let response = try swiftDataClient.searchLinks(query)
          await send(.suggestionResponse(response))
        }
        
      case .suggestionResponse(let item):
        state.suggestionItem = item
        return .none
        
      case .suggestionTapped(let item):
        return .send(.delegate(.openLinkDetail(item)))
        
      case .delegate:
        return .none
      }
    }
  }
}
