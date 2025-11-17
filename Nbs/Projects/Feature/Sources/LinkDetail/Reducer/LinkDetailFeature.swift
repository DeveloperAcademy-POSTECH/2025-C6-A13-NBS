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
  
  private enum CancelID { case editNotification }
  
  @ObservableState
  struct State {
    var link: ArticleItem
    var isEditingTitle = false
    var editedTitle = ""
    var editedMemo = ""
    var isDeleted = false
    var showToast: Bool = false
    
    var summary: SummaryFeature.State
    
    init(article: ArticleItem) {
      self.link = article
      self.isEditingTitle = false
      self.editedTitle = ""
      self.editedMemo = ""
      self.isDeleted = false
      self.showToast = false
      self.summary = SummaryFeature.State(article: article)
    }
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
    case originalArticleTapped
    case refreshed(ArticleItem?)
    
    /// 토스트
    case editCompletedNotification
    case showToast
    case dismissToast
    
    case summary(SummaryFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.summary, action: \.summary) {
      SummaryFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.editedTitle = state.link.title
        state.editedMemo  = state.link.userMemo
        return .merge(
          .run { [linkID = state.link.id] send in
            let linkItem = try swiftDataClient.fetchLink(linkID)
            await send(.refreshed(linkItem))
          },
          .run { send in
            for await _ in NotificationCenter.default.notifications(named: .editCompleted) {
              await send(.editCompletedNotification)
            }
          }
            .cancellable(id: CancelID.editNotification)
        )
        
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
        NotificationCenter.default.post(
          name: .linkDeleted,
          object: ["deletedCount": 1]
        )
        return .none
        
        
      case .deleteResponse(.failure(let error)):
        print("링크 삭제 실패:", error)
        return .none
        
        /// 원문보기
      case .originalArticleTapped:
        let payload = OriginalPayload(articleItem: state.link)
        
        linkNavigator.push(Route.originalArticle, payload)
        return .none
        
      case .refreshed(let item):
        if let item {
          state.link = item
          state.summary.article = item
        }
        return .none
        
      case .editCompletedNotification:
        print("수정 완료")
        return .send(.showToast)
        
      case .showToast:
        state.showToast = true
        return .run { send in
          try await Task.sleep(for: .seconds(2))
          await send(.dismissToast)
        }
        
      case .dismissToast:
        state.showToast = false
        return .none
        
      case .summary:
        return .none
      }
    }
  }
}
