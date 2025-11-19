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
  let store: StoreOf<HighlightEditFeature>
}

// MARK: - View
extension HighlightEditSheetView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack(spacing: 0) {
        SheetHeader(title: store.title) {
          store.send(.dismissButtonTapped)
        }
        
        switch store.context {
        case .comment:
          VStack(spacing: 8) {
            ActionSheetButton(icon: Icon.edit2, title: "수정하기") {
              store.send(.editButtonTapped)
            }
            .padding(.vertical, 8)
            ActionSheetButton(icon: Icon.trash, title: "삭제하기", style: .danger) {
              store.send(.deleteButtonTapped)
            }
            .padding(.vertical, 8)
          }
          .padding(.bottom, 12)
        case .highlight:
          VStack(spacing: 8) {
            ActionSheetButton(icon: Icon.edit2, title: "메모 추가하기") {
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
    }
    .fullScreenCover(isPresented: .constant(store.isShowDeleteModal)) {
      ZStack(alignment: .center) {
        Color.dim.ignoresSafeArea()
        
        AlertDialog(
          title: store.alertTitle,
          subtitle: store.alertSubTitle,
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

