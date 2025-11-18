
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
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
  ]
}

extension EditCategoryIconNameView: View {
  var body: some View {
    ZStack(alignment: .leading) {
      VStack(spacing: 0) {
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

        CategoryIconScrollView(selectedIcon: $store.selectedIcon.sending(\.selectIcon))
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
      
      Color.clear
        .frame(width: 50)
        .padding(.top, 60)
        .contentShape(Rectangle())
        .allowsHitTesting(false)
        .gesture(
          DragGesture()
            .onEnded { value in
              if value.translation.width > 80 {
                store.send(.backGestureSwiped)
              }
            }
        )
    }
    .toolbar(.hidden)
    .ignoresSafeArea(.keyboard)
    .overlay {
      if store.isAlert {
        ZStack {
          Color.dim.ignoresSafeArea()
          AlertDialog(
            title: "카테고리 수정을 중단할까요?",
            subtitle: "페이지를 나가면 수정사항이 저장되지 않아요",
            cancelTitle: "취소",
            onCancel: { store.send(.confirmAlertDismissed) },
            buttonType: .move(title: "나가기", action: {
              store.send(.confirmAlertConfirmButtonTapped)
            })
          )
        }
      }
    }
  }
}
