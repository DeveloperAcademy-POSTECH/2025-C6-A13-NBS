//
//  MoveLinkFeature.swift
//  Feature
//
//  Created by 이안 on 10/22/25.
//

import SwiftUI
import ComposableArchitecture
import Domain

@Reducer
struct MoveLinkFeature {
  @ObservableState
  struct State: Equatable {
    var allLinks: [LinkItem] = []
    var selectedLinks: Set<LinkItem.ID> = []
    var isSelectAll: Bool = false
  }
  
  enum Action {
    case onAppear
    case toggleSelect(LinkItem)
    case toggleSelectAll
    case cancelTapped
    case confirmMoveTapped
    case delegate(Delegate)
    
    enum Delegate {
      case dismiss
      case confirmMove(selected: [LinkItem])
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
        
      case let .toggleSelect(link):
        if state.selectedLinks.contains(link.id) {
          state.selectedLinks.remove(link.id)
        } else {
          state.selectedLinks.insert(link.id)
        }
        state.isSelectAll = (state.selectedLinks.count == state.allLinks.count)
        return .none
        
      case .toggleSelectAll:
        if state.isSelectAll {
          state.selectedLinks.removeAll()
          state.isSelectAll = false
        } else {
          state.selectedLinks = Set(state.allLinks.map(\.id))
          state.isSelectAll = true
        }
        return .none
        
      case .cancelTapped:
        return .send(.delegate(.dismiss))
        
      case .confirmMoveTapped:
        let selected = state.allLinks.filter { state.selectedLinks.contains($0.id) }
        return .send(.delegate(.confirmMove(selected: selected)))
        
      case .delegate:
        return .none
      }
    }
  }
}
