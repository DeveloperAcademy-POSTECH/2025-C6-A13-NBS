//
//  HighlightEditFeature.swift
//  Feature
//
//  Created by 여성일 on 11/10/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct HighlightEditFeature {
  @Dependency(\.dismiss) var dismiss
  
  @ObservableState
  struct State: Equatable {
    var comment: Comment
    var isShowDeleteModal: Bool = false
  }
  
  enum Action: Equatable {
    case dismissButtonTapped
    case editButtonTapped
    case deleteButtonTapped
    case confirmDeleteButtonTapped
    case canceleDeleteButtonTapped
    
    enum Delegate: Equatable {
      case dismiss
      case edit
      case delete(Comment)
    }
    case delegate(Delegate)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .dismissButtonTapped:
        return .send(.delegate(.dismiss))
      case .editButtonTapped:
        return .send(.delegate(.edit))
      case .deleteButtonTapped:
        state.isShowDeleteModal = true
        return .none
      case .confirmDeleteButtonTapped:
        return .run { [comment = state.comment] send in
          await send(.canceleDeleteButtonTapped)
          await send(.delegate(.delete(comment)))
          await send(.delegate(.dismiss))
        }
      case .canceleDeleteButtonTapped:
        state.isShowDeleteModal = false
        return .none
      case .delegate:
        return .none
      }
    }
  }
}
