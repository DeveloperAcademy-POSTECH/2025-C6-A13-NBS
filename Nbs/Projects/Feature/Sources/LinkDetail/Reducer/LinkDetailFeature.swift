//
//  LinkDetailFeature.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI
import ComposableArchitecture
import Domain
import DesignSystem

@Reducer
struct LinkDetailFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State {
    var link: ArticleItem
    var isEditingTitle = false
    var editedTitle = ""
    var editedMemo = ""
    var isDeleted = false
  }
  
  enum Action {
    case onAppear
    
    /// 제목
    case editButtonTapped
    case titleChanged(String)
    case titleFocusChanged(Bool)
    case saveIfNeeded
    case saveResponse(TaskResult<Void>)
    
    /// 메모
    case memoChanged(String)
    case memoFocusChanged(Bool)
    case saveMemoIfNeeded
    case saveMemoResponse(TaskResult<Void>)
    
    /// 삭제
    case deleteTapped
    case deleteResponse(TaskResult<Void>)
    
    /// 원문보기
    case originalArticleTapped(URL)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.editedTitle = state.link.title
        state.editedMemo  = state.link.userMemo
        return .none
        
        /// 제목 편집
      case .editButtonTapped:
        state.isEditingTitle = true
        state.editedTitle = state.link.title
        return .none
        
      case .titleChanged(let text):
        state.editedTitle = text
        return .none
        
      case .titleFocusChanged(false):
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
        print("제목 수정 실패:", error)
        return .none
        
        /// 메모
      case let .memoChanged(text):
        state.editedMemo = text
        return .none
        
      case let .memoFocusChanged(hasFocus):
        if hasFocus == false {
          return .send(.saveMemoIfNeeded)
        }
        return .none
        
      case .saveMemoIfNeeded:
        let next = state.editedMemo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard next != state.link.userMemo else { return .none }
        let id = state.link.id
        return .run { send in
          await send(.saveMemoResponse(TaskResult {
            try swiftDataClient.updateLinkMemo(id, next)
          }))
        }
        
      case .saveMemoResponse(.success):
        state.link.userMemo = state.editedMemo.trimmingCharacters(in: .whitespacesAndNewlines)
        return .none
        
      case .saveMemoResponse(.failure(let error)):
        print("save memo failed:", error)
        return .none
        
        /// 삭제
      case .deleteTapped:
        let id = state.link.id
        return .run { send in
          await send(.deleteResponse(TaskResult {
            try swiftDataClient.deleteLinkById(id)
          }))
        }
        
      case .deleteResponse(.success):
        state.isDeleted = true
        return .none
        
        
      case .deleteResponse(.failure(let error)):
        print("링크 삭제 실패:", error)
        return .none
        
      /// 원문보기
      case .originalArticleTapped(let url):
        linkNavigator.push(Route.originalArticle, url.absoluteString)
        return .none
      }
    }
  }
}
