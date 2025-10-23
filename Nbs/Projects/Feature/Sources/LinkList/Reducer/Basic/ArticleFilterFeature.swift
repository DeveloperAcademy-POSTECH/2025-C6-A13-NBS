//
//  ArticleFilterFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct ArticleFilterFeature {
  
  @ObservableState
  struct State {
    var link: [LinkItem] = []
    var sortOrder: SortOrder = .latest
    var selectedLink: LinkItem? = nil
  }
  
  enum SortOrder: Equatable {
    case latest
    case oldest
  }
  
  enum Action {
    case listCellTapped(LinkItem)
    case listCellLongPressed(LinkItem)
    case sortOrderChanged(SortOrder)
    case delegate(Delegate)
    enum Delegate {
      case openLinkDetail(LinkItem)
      case longPressed(LinkItem)
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .listCellTapped(link):
        state.selectedLink = link
        return .send(.delegate(.openLinkDetail(link)))
        
      case let .listCellLongPressed(link):
        return .send(.delegate(.longPressed(link)))
        
      case let .sortOrderChanged(order):
        state.sortOrder = order
        
        switch order {
        case .latest:
          state.link.sort { $0.createAt > $1.createAt }
        case .oldest:
          state.link.sort { $0.createAt < $1.createAt }
        }
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}
