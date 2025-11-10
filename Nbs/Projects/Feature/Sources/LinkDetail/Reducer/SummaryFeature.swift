//
//  SummaryFeature.swift
//  Feature
//
//  Created by 여성일 on 11/10/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct SummaryFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State: Equatable {
    @Presents var hightlightEditSheet: HighlightEditFeature.State?
    var article: ArticleItem
  }
  
  enum Action: Equatable {
    case commentLongpress(Comment)
    
    case hightlightEditSheet(PresentationAction<HighlightEditFeature.Action>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .commentLongpress(let comment):
        print("Longpress")
        state.hightlightEditSheet = .init(comment: comment)
        return .none
        
      case .hightlightEditSheet(.presented(.delegate(.dismiss))):
        state.hightlightEditSheet = nil
        return .none
        
      case .hightlightEditSheet(.presented(.delegate(.delete(let comment)))):
        print(comment)
        guard let highlightIndex = state.article.highlights.firstIndex(where: { $0.comments.contains(comment)}) else {
          return .none
        }
        let highlightId = state.article.highlights[highlightIndex].id
        let commentId = comment.id
        
        state.article.highlights[highlightIndex].comments.removeAll { $0.id == comment.id }
        
        return .run { _ in
          do {
            try self.swiftDataClient.deleteComment(commentId, highlightId)
          } catch {
            print("코멘트 삭제 실패")
          }
        }
        .cancellable(id: "delete-comment-\(commentId)")
      
      case .hightlightEditSheet(.presented(.delegate(.edit))):
        print("edit")
        return .none
        
      case .hightlightEditSheet:
        return .none
      }
    }
    .ifLet(\.$hightlightEditSheet, action: \.hightlightEditSheet) {
      HighlightEditFeature()
    }
  }
}

