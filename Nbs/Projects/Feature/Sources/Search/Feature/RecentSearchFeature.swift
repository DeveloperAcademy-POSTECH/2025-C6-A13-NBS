//
//  RecentSearchFeature.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RecentSearchFeature {
  @ObservableState
  struct State: Equatable {
    var searches: IdentifiedArrayOf<SearchTerm> = []
  }
  
  enum Action: Equatable {
    case onAppear
    case loadRecentSearches([String]) // 최근 검색어 불러오기
    case add(String) // 최근 검색어 저장하기
    case del(id: SearchTerm.ID) // 최근 검색어 삭제하기
    case clear // 모든 최근 검색어 삭제하기
    case chipTapped(String)
    
    case delegate(DelegateAction)
  }
  
  enum DelegateAction: Equatable {
    case chipTapped(String)
  }
  
  @Dependency(\.recentSearchClient) var recentSearchClient
  @Dependency(\.uuid) var uuid
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let recentSearchItems = try await recentSearchClient.load()
          await send(.loadRecentSearches(recentSearchItems))
        }
        
      case .loadRecentSearches(let term):
        state.searches = IdentifiedArray(uniqueElements: term.map { SearchTerm(id: uuid(), text: $0)})
        return .none
        
      case .add(let term):
        return .run { send in
          let updateSearches = try await recentSearchClient.add(term)
          await send(.loadRecentSearches(updateSearches))
        }
        
      case .del(let id):
        guard let deleteItem = state.searches[id: id] else { return .none }
        return .run { send in
          let updateSearches = try await recentSearchClient.remove(deleteItem.text)
          await send(.loadRecentSearches(updateSearches))
        }
        
      case .clear:
        return .run { send in
          let updateSearches = try await recentSearchClient.clear()
          await send(.loadRecentSearches(updateSearches))
        }
        
      case .chipTapped(let term):
        return .send(.delegate(.chipTapped(term)))
        
      case .delegate:
        return .none
      }
    }
  }
}
