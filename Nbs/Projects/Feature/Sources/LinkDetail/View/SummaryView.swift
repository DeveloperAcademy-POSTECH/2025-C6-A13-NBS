//
//  SummaryView.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI
import Domain
import DesignSystem

import ComposableArchitecture

struct SummaryView: View {
  let link: ArticleItem
  @Bindable var store: StoreOf<SummaryFeature>
  @FocusState private var isCommentTextFieldFocused: Bool
  @FocusState private var isNewCommentTextFieldFocused: Bool
}

extension SummaryView {
  var body: some View {
    VStack(spacing: 32) {
      ForEach(groupedHighlights.keys.sorted(by: sortOrder), id: \.self) { key in
        if let items = groupedHighlights[key],
           let displayType = displayType(forModelKey: key) {
          VStack(alignment: .leading, spacing: 16) {
            SummaryTypeItem(type: displayType)
            
            // 같은 모델 타입에 묶인 하이라이트들
            ForEach(items) { item in
              highlightContents(for: item, type: displayType)
            }
          }
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, 24)
    .padding(.bottom, 16)
    .background(Color.background)
    .sheet(item: $store.scope(state: \.hightlightEditSheet, action: \.hightlightEditSheet)) { store in
      HighlightEditSheetView(
        store: store
      )
      .presentationDetents([.height(164)])
      .presentationCornerRadius(16)
    }
    .bind($store.isCommentTextFieldFocused, to: self.$isCommentTextFieldFocused)
    .bind($store.isNewCommentTextFieldFocused, to: self.$isNewCommentTextFieldFocused)
  }
  
  /// 하이라이트 섹션
  private func highlightContents(for item: HighlightItem, type: SummaryTypeItem.SummaryType) -> some View {
    VStack(alignment: .leading, spacing: .zero) {
      // 문장 (하이라이팅)
      Text(item.sentence)
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(type.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onLongPressGesture(minimumDuration: 0.5) {
          let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
          impactFeedback.impactOccurred()
          store.send(.highlightLongpress(item))
        }
      
      // 코멘트 리스트
      VStack(alignment: .leading, spacing: .zero) {
        if !item.comments.isEmpty {
          ForEach(item.comments, id: \.id) { comment in
            if store.editingCommentId == comment.id {
              TextEditor(text: $store.editedCommentText.sending(\.commentTextFieldChanged))
                .font(.B3_R_HLM)
                .foregroundStyle(.text1)
                .padding(.vertical, 8)
                .padding(.horizontal, 11)
                .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                .scrollContentBackground(.hidden)
                .background(.n20)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .focused($isCommentTextFieldFocused)
                .toolbar {
                  ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("완료") {
                      store.send(.saveCommentButtonTapped)
                    }
                  }
                }
            } else {
              VStack(spacing: .zero) {
                Text("\(comment.text)")
                  .font(.B3_R_HLM)
                  .foregroundStyle(.text1)
                  .padding(16)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(.n20)
                  .clipShape(RoundedRectangle(cornerRadius: 12))
                  .onLongPressGesture(minimumDuration: 0.5) {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                    impactFeedback.impactOccurred()
                    store.send(.commentLongpress(comment))
                  }
                  .padding(.vertical, 16)
                
                Rectangle()
                  .fill(.divider1)
                  .frame(height: 1)
              }
            }
          }
        }
        
        if store.addingCommentToHighlightId == item.id {
          TextEditor(text: $store.newCommentText.sending(\.newCommentTextChanged))
            .font(.B3_R_HLM)
            .foregroundStyle(.text1)
            .padding(.vertical, 8)
            .padding(.horizontal, 11)
            .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
            .scrollContentBackground(.hidden)
            .background(.n20)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .focused($isNewCommentTextFieldFocused)
            .toolbar {
              ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") {
                  store.send(.saveNewCommentButtonTapped)
                }
              }
            }
        }
      }
    }
  }
  
  /// 보여줄 타입
  private func displayType(forModelKey key: String) -> SummaryTypeItem.SummaryType? {
    switch key.lowercased() {
    case "what":   return .pink
    case "why":    return .yellow
    case "detail": return .blue
    default:       return nil
    }
  }
  
  ///  type별 그룹핑된 highlights
  private var groupedHighlights: [String: [HighlightItem]] {
    Dictionary(grouping: link.highlights) { item in
      item.type.capitalized
    }
  }
  
  /// 출력 순서 (What -> Why ->  Detail)
  private func sortOrder(lhs: String, rhs: String) -> Bool {
    let order: [String: Int] = ["What": 0, "Why": 1, "Detail": 2]
    return (order[lhs] ?? 99) < (order[rhs] ?? 99)
  }
}
