//
//  OriginalEditFeature.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import ComposableArchitecture
import Foundation

import Domain

@Reducer
struct OriginalEditFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State: Equatable {
    var articleItem: ArticleItem
    var isDataRequestTriggered: Bool = false
  }
  
  enum Action: Equatable {
    case completeButtonTapped
    case highlightsDataResponse([HighlightPayload])
  }
  
  var body: some ReducerOf<Self> {
    Reduce {
      state,
      action in
      switch action {
      case .completeButtonTapped:
        state.isDataRequestTriggered = true
        return .none
        
      case .highlightsDataResponse(let highlights):
        return .run { [linkID = state.articleItem.id] _ in
          do {
            let highlights = highlights.map { payload in
              HighlightItem(
                id: payload.id,
                sentence: payload.sentence,
                type: payload.type,
                createdAt: Date(),
                comments: payload.comments
              )
            }
            try swiftDataClient.updateHighlightsForLink(linkID, highlights)

            await linkNavigator.pop()
            
            try await Task.sleep(for: .milliseconds(300))
            NotificationCenter.default.post(name: .editCompleted, object: nil)
          } catch {
            print("저장 실패")
          }
        }
      }
    }
  }
}

extension Notification.Name {
  static let editCompleted = Notification.Name("editCompleted")
}
