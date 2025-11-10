//
//  HighlightEditSheetView.swift
//  Feature
//
//  Created by 여성일 on 11/10/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

// MARK: - Properties
struct HighlightEditSheetView: View {
  let title: String
  let store: StoreOf<HighlightEditFeature>
}

// MARK: - View
extension HighlightEditSheetView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack(spacing: 0) {
        SheetHeader(title: title) {
          store.send(.dismissButtonTapped)
        }
        VStack(spacing: 8) {
          ActionSheetButton(icon: Icon.edit, title: "수정하기") {
            store.send(.editButtonTapped)
          }
          .padding(.vertical, 8)
          ActionSheetButton(icon: Icon.trash, title: "삭제하기", style: .danger) {
            store.send(.deleteButtonTapped)
          }
          .padding(.vertical, 8)
        }
        .padding(.bottom, 12)
      }
    }
    .fullScreenCover(isPresented: .constant(store.isShowDeleteModal)) {
      ZStack {
        Color.dim.ignoresSafeArea()
        
        AlertDialog(
          title: "해당 메모를 삭제할까요?",
          subtitle: "삭제한 메모는 복구할 수 없어요",
          onCancel: { store.send(.canceleDeleteButtonTapped)},
          buttonType: .delete(title: "삭제", action: {
            store.send(.confirmDeleteButtonTapped)
          })
        )
      }
      .background(AlertClearBackgroundView())
    }
    .transaction { transaction in
      transaction.disablesAnimations = true
    }
  }
}

