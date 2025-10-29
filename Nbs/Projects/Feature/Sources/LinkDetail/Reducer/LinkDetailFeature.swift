//
//  LinkDetailFeature.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct LinkDetailFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State: Equatable {
    var link: ArticleItem
    var isEditingTitle = false
    var editedTitle = ""
  }
  
  enum Action {
    case onAppear
    case editButtonTapped
    case titleChanged(String)
    case titleFocusChanged(Bool)
    case saveIfNeeded
    case saveResponse(TaskResult<Void>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
        
      case .editButtonTapped:
        state.isEditingTitle = true
        state.editedTitle = state.link.title
        return .none
        
      case .titleChanged(let text):
        state.editedTitle = text
        return .none
        
      case .titleFocusChanged(false): // 포커스 해제 시
        let current = state.link.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let next = state.editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        state.isEditingTitle = false
        if !next.isEmpty, next != current {
          return .send(.saveIfNeeded)
        }
        return .none
        
      case .titleFocusChanged(true):
        return .none
        
      case .saveIfNeeded:
        let id = state.link.id
        let newTitle = state.editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !newTitle.isEmpty, newTitle != state.link.title else { return .none }
        return .run { send in
          await send(.saveResponse(TaskResult {
            try swiftDataClient.editLinkTitle(id, newTitle)
          }))
        }
        
      case .saveResponse(.success):
        state.link.title = state.editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        return .none
        
      case .saveResponse(.failure(let error)):
        print("❌ 제목 수정 실패:", error)
        return .none
      }
    }
  }
}
