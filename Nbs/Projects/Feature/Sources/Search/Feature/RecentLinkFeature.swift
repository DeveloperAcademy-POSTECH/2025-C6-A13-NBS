//
//  RecentLinkFeature.swift
//  Feature
//
//  Created by 여성일 on 10/21/25.
//

import ComposableArchitecture

import Domain

@Reducer
struct RecentLinkFeature {
  @ObservableState
  struct State: Equatable {
    var recentLinkItem: [ArticleItem] = []
  }
  
  enum Action: Equatable {
    case onAppear
    case recentLinkResponse([ArticleItem])
    case recentLinkTapped(ArticleItem)
    
    case delegate(DelegateAction)
  }
  
  enum DelegateAction: Equatable {
    case openLinkDetail(ArticleItem)
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let links = try swiftDataClient.fetchRecentLinks()
          await send(.recentLinkResponse(links))
        }
      
      case .recentLinkResponse(let items):
        state.recentLinkItem = items
        return .none
      
      case .recentLinkTapped(let item):
        return .send(.delegate(.openLinkDetail(item)))
        
      case .delegate:
        return .none
      }
    }
  }
}
