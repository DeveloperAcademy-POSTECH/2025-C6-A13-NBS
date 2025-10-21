//
//  SearchResultFeature.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import ComposableArchitecture

import Foundation

import Domain

@Reducer
struct SearchResultFeature {
  @ObservableState
  struct State: Equatable {
    var searchResult: [LinkItem] = []
    var query: String = ""
  }
  
  enum Action: Equatable {
    case loadSearchResult(String)
    case searchResponse([LinkItem])
    case linkCardTapped(LinkItem)
    case categoryButtonTapped
    
    case delegate(DelegateAction)
  }
  
  enum DelegateAction: Equatable {
    case openLinkDetail(LinkItem)
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .loadSearchResult(let query):
        state.query = query
        return .run { send in
          let response = try swiftDataClient.searchLinks(query)
          await send(.searchResponse(response))
        }
      
      case .searchResponse(let item):
        state.searchResult = item
        return .none
      
      case .linkCardTapped(let item):
        return .send(.delegate(.openLinkDetail(item)))
        
      case .categoryButtonTapped:
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}
