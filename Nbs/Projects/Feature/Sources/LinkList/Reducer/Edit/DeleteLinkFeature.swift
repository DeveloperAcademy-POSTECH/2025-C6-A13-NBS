//
//  DeleteLinkFeature.swift
//  Feature
//
//  Created by 이안 on 10/22/25.
//

import SwiftUI
import ComposableArchitecture
import Domain

@Reducer
struct DeleteLinkFeature {
  @ObservableState
  struct State: Equatable {
    var allLinks: [ArticleItem] = []
    var selectedLinks: Set<String> = []
    var isSelectAll: Bool = false
    var hideSelectControls: Bool = false
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case onAppear
    case toggleSelect(ArticleItem)
    case cancelTapped
    case confirmDeleteTapped
    case delegate(Delegate)
    
    enum Delegate {
      case dismiss
      case confirmDelete(selected: [ArticleItem])
    }
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        if state.hideSelectControls {
          state.selectedLinks = Set(state.allLinks.map(\.id))
          state.isSelectAll = true
        }
        return .none
        
        /// 전체 선택 or 해제
      case .binding(\.isSelectAll):
        if state.isSelectAll {
          state.selectedLinks = Set(state.allLinks.map(\.id))
        } else {
          state.selectedLinks.removeAll()
        }
        return .none
        
        /// 개별 토글 시 전체선택 여부 갱신
      case let .toggleSelect(link):
        if state.selectedLinks.contains(link.id) {
          state.selectedLinks.remove(link.id)
        } else {
          state.selectedLinks.insert(link.id)
        }
        state.isSelectAll = state.selectedLinks.count == state.allLinks.count
        return .none
        
      case .cancelTapped:
        return .send(.delegate(.dismiss))
        
      case .confirmDeleteTapped:
        let selected = state.allLinks.filter { state.selectedLinks.contains($0.id) }
        return .send(.delegate(.confirmDelete(selected: selected)))
        
      case .binding, .delegate:
        return .none
      }
    }
  }
}
