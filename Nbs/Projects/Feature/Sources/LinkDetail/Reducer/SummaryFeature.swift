//
//  SummaryFeature.swift
//  Feature
//
//  Created by 여성일 on 11/10/25.
//

import ComposableArchitecture
import Domain
import SwiftUI

@Reducer
struct SummaryFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State: Equatable {
    @Presents var hightlightEditSheet: HighlightEditFeature.State?
    var article: ArticleItem
    
    var editingCommentId: Double?
    var editedCommentText: String = ""
    var isCommentTextFieldFocused: Bool = false
  }
  
  enum Action: Equatable, BindableAction {
    case commentLongpress(Comment)
    case commentTextFieldChanged(String)
    case saveCommentButtonTapped
    
    case highlightLongpress(HighlightItem)
    case binding(BindingAction<State>)
    
    case hightlightEditSheet(PresentationAction<HighlightEditFeature.Action>)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .commentLongpress(let comment):
        print("Longpress")
        state.hightlightEditSheet = .init(context: .comment(comment))
        return .none
        
      case .commentTextFieldChanged(let text):
        state.editedCommentText = text
        return .none
      
      case .saveCommentButtonTapped:
        guard let editingId = state.editingCommentId else {
          return .none
        }
        
        guard let highlightIndex = state.article.highlights.firstIndex(where: { $0.comments.contains(where: { $0.id == editingId })}) else {
          return .none
        }
        
        guard let commentIndex = state.article.highlights[highlightIndex]
          .comments.firstIndex(where: { $0.id == editingId }) else {
          return .none
        }
        
        let originalComment = state.article.highlights[highlightIndex].comments[commentIndex]
        let updateComment = Comment(id: originalComment.id, type: originalComment.type, text: state.editedCommentText)
        state.article.highlights[highlightIndex].comments[commentIndex] = updateComment
        
        state.editingCommentId = nil
        
        let highlightId = state.article.highlights[highlightIndex].id
        let newText = state.editedCommentText
        
        return .run { _ in
          do {
            try self.swiftDataClient.editComment(editingId, newText, highlightId)
          } catch {
            print("")
          }
        }
        .cancellable(id: "edit-comment-\(editingId)")
      
      case .highlightLongpress(let highlightItem):
        state.hightlightEditSheet = .init(context: .highlight(highlightItem))
        return .none
        
      case .binding(\.isCommentTextFieldFocused):
        if state.isCommentTextFieldFocused == false {
          return .send(.saveCommentButtonTapped)
        }
        return .none
        
      case .hightlightEditSheet(.presented(.delegate(.dismiss))):
        state.hightlightEditSheet = nil
        return .none
        
      case .hightlightEditSheet(.presented(.delegate(.delete(let context)))):
        switch context {
        case .comment(let comment):
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
        case .highlight(let highlight):
          guard let highlightIndex = state.article.highlights.firstIndex(where: { $0.id == highlight.id }) else {
            return .none
          }
          
          state.article.highlights.remove(at: highlightIndex)
          
          let highlightId = highlight.id
          
          return .run { _ in
            do {
              try self.swiftDataClient.deleteHighlight(highlightId)
            } catch {
              print("")
            }
          }
        }
        
      case .hightlightEditSheet(.presented(.delegate(.edit(let context)))):
        switch context {
        case .comment(let comment):
          state.hightlightEditSheet = nil
          state.editingCommentId = comment.id
          state.editedCommentText = comment.text
          state.isCommentTextFieldFocused = true
          return .none
        case .highlight(let highlight):
          return .none
        }
        
      case .hightlightEditSheet:
        return .none
      
      case .binding:
        return .none
      }
    }
    .ifLet(\.$hightlightEditSheet, action: \.hightlightEditSheet) {
      HighlightEditFeature()
    }
  }
}

