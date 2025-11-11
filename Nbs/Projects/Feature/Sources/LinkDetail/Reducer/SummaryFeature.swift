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
    
    var addingCommentToHighlightId: String?
    var newCommentText: String = ""
    var isNewCommentTextFieldFocused: Bool = false
  }
  
  enum Action: Equatable, BindableAction {
    case commentLongpress(Comment)
    case commentTextFieldChanged(String)
    case saveCommentButtonTapped
    
    case highlightLongpress(HighlightItem)
    case newCommentTextChanged(String)
    case saveNewCommentButtonTapped
    
    case binding(BindingAction<State>)
    
    case hightlightEditSheet(PresentationAction<HighlightEditFeature.Action>)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .commentLongpress(let comment):
        state.hightlightEditSheet = .init(context: .comment(comment))
        return .none
        
      case .commentTextFieldChanged(let text):
        state.editedCommentText = text
        return .none
      
      case .saveCommentButtonTapped:
        state.isCommentTextFieldFocused = false
        guard let editingId = state.editingCommentId else { return .none }
        
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
          try swiftDataClient.editComment(editingId, newText, highlightId)
        }
        .cancellable(id: "edit-comment-\(editingId)")
      
      case .highlightLongpress(let highlightItem):
        state.hightlightEditSheet = .init(context: .highlight(highlightItem))
        return .none
        
      case .newCommentTextChanged(let text):
        state.newCommentText = text
        return .none
        
      case .saveNewCommentButtonTapped:
        state.isNewCommentTextFieldFocused = false
        guard let highlightId = state.addingCommentToHighlightId, !state.newCommentText.isEmpty else {
          state.addingCommentToHighlightId = nil
          return .none
        }
        
        guard let highlightIndex = state.article.highlights.firstIndex(where: { $0.id == highlightId }) else {
          return .none
        }
        
        let newComment = Comment(id: Date().timeIntervalSince1970, type: state.article.highlights[highlightIndex].type, text:
              state.newCommentText)
        
        state.addingCommentToHighlightId = nil
        
        return .run { _ in
          try swiftDataClient.addComment(newComment, highlightId)
        }
        .cancellable(id: "add-comment-\(newComment.id)")
        
      case .binding(let action):
        switch action.keyPath {
        case \.isCommentTextFieldFocused:
          if state.isCommentTextFieldFocused == false {
            return .send(.saveCommentButtonTapped)
          }
        case \.isNewCommentTextFieldFocused:
          if state.isNewCommentTextFieldFocused == false {
            return .send(.saveNewCommentButtonTapped)
          }
        default:
          break
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
            try swiftDataClient.deleteComment(commentId, highlightId)
          }
          .cancellable(id: "delete-comment-\(commentId)")
          
        case .highlight(let highlight):
          guard let highlightIndex = state.article.highlights.firstIndex(where: { $0.id == highlight.id }) else {
            return .none
          }
          
          state.article.highlights.remove(at: highlightIndex)
          
          let highlightId = highlight.id
          
          return .run { _ in
            try self.swiftDataClient.deleteHighlight(highlightId)
          }
        }
        
      case .hightlightEditSheet(.presented(.delegate(.edit(let comment)))):
        state.hightlightEditSheet = nil
        state.editingCommentId = comment.id
        state.editedCommentText = comment.text
        state.isCommentTextFieldFocused = true
        return .none
      
      case .hightlightEditSheet(.presented(.delegate(.add(let highlight)))):
        state.hightlightEditSheet = nil
        state.addingCommentToHighlightId = highlight.id
        state.newCommentText = ""
        state.isNewCommentTextFieldFocused = true
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


