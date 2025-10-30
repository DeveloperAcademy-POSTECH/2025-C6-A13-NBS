//
//  AddLinkView.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct AddLinkView: View {
  
  @Bindable var store: StoreOf<AddLinkFeature>
  @FocusState private var isFocused: Bool
  @State private var isValidURL: Bool = true
  
  var body: some View {
    VStack {
      TopAppBarDefaultRightIconxFeatureView(
        store: store.scope(
          state: \.topAppBar,
          action: \.topAppBar
        )
      )
      
      JNTextFieldLink(
        text: $store.linkURL.sending(\.setLinkURL),
        style: isValidURL ? .default : .errorCaption,
        placeholder: "링크를 입력해주세요",
        header: "추가할 링크",
        isValidURL: $isValidURL
      )
      .focused($isFocused)
      
      VStack {
        HStack {
          Text(AddLinkNamespace.selectCategory)
            .font(.B2_SB)
            .foregroundStyle(.caption1)
          Spacer()
          
          AddNewCategoryButton{
            store.send(.addNewCategoryButtonTapped)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.top, 24)
        
        CategoryGridView(
          store: store.scope(
            state: \.categoryGrid,
            action: \.categoryGrid
          )
        )
        
        Spacer()
        MainButton(
          AddLinkNamespace.ctaButtonTitle,
          isDisabled: store.linkURL.isEmpty || !isValidURL
        ) {
          store.send(.saveButtonTapped)
        }
        .padding(.horizontal, 20)
      }
      .overlay(isFocused ? Color.white.opacity(0.3) : Color.clear)
    }
    .ignoresSafeArea(.keyboard)
    .navigationBarHidden(true)
    .background(DesignSystemAsset.background.swiftUIColor)
    .overlay {
      if store.isConfirmAlertPresented {
        ZStack {
          Color.dim.ignoresSafeArea()
          AlertDialog(
            title: "링크 추가를 중단할까요?",
            subtitle: "페이지를 나가면 링크가 저장되지 않아요",
            cancelTitle: "취소",
            onCancel: { store.send(.confirmAlertDismissed) },
            buttonType: .move(title: "나가기") {
              store.send(.confirmAlertConfirmButtonTapped)
            }
          )
        }
      }
    }
    .highPriorityGesture(
      DragGesture(minimumDistance: 25, coordinateSpace: .local)
        .onEnded { value in
          if value.startLocation.x < 50 && value.translation.width > 80 {
            store.send(.backGestureSwiped)
          }
        }
    )
  }
}

#Preview {
  AddLinkView(store: Store(initialState: AddLinkFeature.State()) {
    AddLinkFeature()
  })
}
