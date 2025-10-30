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
    var suggestionItem: [ArticleItem] = []
  }
  
  enum Action: Equatable {
    case loadSuggestionItem(String)
    case suggestionResponse([ArticleItem])
    case suggestionTapped(ArticleItem)
  }

  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var linkNavigator
  
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
        linkNavigator.push(.linkDetail, item)
        return .none
      }
    }
  }
}
