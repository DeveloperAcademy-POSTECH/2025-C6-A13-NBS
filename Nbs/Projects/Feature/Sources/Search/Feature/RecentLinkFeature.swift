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
    var recentLinkItem: [LinkItem] = []
  }
  
  enum Action: Equatable {
    case onAppear
    case recentLinkResponse([LinkItem])
    case recentLinkTapped(LinkItem)
    
    case delegate(DelegateAction)
  }
  
  enum DelegateAction: Equatable {
    case openLinkDetail(LinkItem)
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
