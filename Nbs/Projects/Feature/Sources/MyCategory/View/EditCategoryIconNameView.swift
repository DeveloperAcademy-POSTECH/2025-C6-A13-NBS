
//
//  EditCategoryIconName.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem
import Domain

struct EditCategoryIconNameView {
  @Bindable var store: StoreOf<EditCategoryIconNameFeature>
  @FocusState private var isFocused: Bool
  
  let columns = [
    GridItem(.flexible(), spacing: 10),
    GridItem(.flexible(), spacing: 10),
    GridItem(.flexible(), spacing: 10)
  ]
}

extension EditCategoryIconNameView: View {
  var body: some View {
    VStack {
      TopAppBarDefaultRightIconx(title: "카테고리 수정하기") {
        store.send(.topAppBar(.tapBackButton))
      }
      
      JNTextField(
        text: $store.categoryName.sending(\.setCategoryName),
        style: $store.textFieldStyle.sending(\.setTextFieldStyle),
        placeholder: "카테고리명을 입력해주세요",
        caption: "이미 존재하는 카테고리예요",
        header: "카테고리명"
      )
      .focused($isFocused)
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          Button("완료") {
            isFocused = false
          }
        }
      }
      
      CategoryIconScrollView(
        selectedIcon: $store.selectedIcon.sending(\.selectIcon),
        isFocused: isFocused
      )
      
      MainButton(
        "완료",
        isDisabled: store.categoryName.isEmpty,
        hasGradient: true
      ) {
        store.send(.compeleteButtonTapped)
      }
    }
    .background(DesignSystemAsset.background.swiftUIColor)
    .onTapGesture {
      isFocused = false
    }
    .toolbar(.hidden)
    .ignoresSafeArea(.keyboard)
  }
}
