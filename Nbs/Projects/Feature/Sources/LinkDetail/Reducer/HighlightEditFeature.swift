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
    enum Context: Equatable {
      case comment(Comment)
      case highlight(HighlightItem)
    }
    
    var context: Context
    var isShowDeleteModal: Bool = false
    
    var title: String {
      switch context {
      case .highlight:
        return "하이라이트 편집"
      case .comment:
        return "하이라이트 메모 편집"
      }
    }
    
    var alertTitle: String {
      switch context {
      case .highlight:
        return "해당 하이라이트 삭제할까요?"
      case .comment:
        return "해당 메모를 삭제할까요?"
      }
    }
    
    var alertSubTitle: String {
      switch context {
      case .highlight:
        return "메모도 함께 삭제 되며,\n삭제한 하이라이트는 복구할 수 없어요"
      case .comment:
        return "삭제한 메모는 복구할 수 없어요"
      }
    }
  }
  
  enum Action: Equatable {
    case dismissButtonTapped
    case editButtonTapped
    case deleteButtonTapped
    case confirmDeleteButtonTapped
    case canceleDeleteButtonTapped
    
    enum Delegate: Equatable {
      case dismiss
      case add(HighlightItem)
      case edit(Comment)
      case delete(State.Context)
    }
    case delegate(Delegate)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .dismissButtonTapped:
        return .send(.delegate(.dismiss))
      case .editButtonTapped:
        switch state.context {
        case .comment(let comment):
          return .send(.delegate(.edit(comment)))
        case .highlight(let highlight):
          return .send(.delegate(.add(highlight)))
        }
      case .deleteButtonTapped:
        state.isShowDeleteModal = true
        return .none
      case .confirmDeleteButtonTapped:
        state.isShowDeleteModal = false
        return .merge(
          .send(.delegate(.delete(state.context))),
          .send(.delegate(.dismiss))
        )
      case .canceleDeleteButtonTapped:
        state.isShowDeleteModal = false
        return .none
      case .delegate:
        return .none
      }
    }
  }
}
