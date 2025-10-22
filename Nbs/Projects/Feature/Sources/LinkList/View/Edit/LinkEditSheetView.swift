//
//  LinkEditSheetView.swift
//  Feature
//
//  Created by 이안 on 10/21/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct LinkEditSheetView: View {
  @Bindable var store: StoreOf<EditSheetFeature>
  
  var body: some View {
    VStack(spacing: 8) {
      SheetHeader(title: "링크 편집") {
        store.send(.dismissButtonTapped)
      }
      
      VStack(spacing: 12) {
        ActionSheetButton(icon: Icon.move, title: "이동하기") {
          store.send(.moveButtonTapped)
        }
        
        ActionSheetButton(icon: Icon.trash, title: "삭제하기", style: .danger) {
          store.send(.deleteButtonTapped)
        }
      }
    }
    .padding(.bottom, 60)
  }
}
