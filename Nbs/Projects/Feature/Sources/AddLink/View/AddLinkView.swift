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
      ZStack(alignment: .topLeading) {
        VStack {
          TopAppBarDefaultRightIconx(title: "링크 추가하기") {
            store.send(.backGestureSwiped)
          }
          
          JNTextFieldLink(
            text: $store.linkURL.sending(\.setLinkURL),
            style: isValidURL ? .default : .errorCaption,
            placeholder: "링크를 입력해주세요",
            header: "추가할 링크",
            isValidURL: $isValidURL
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
              isDisabled: store.linkURL.isEmpty || !isValidURL || store.isURLExisting || store.selectedCategory == nil,
              hasGradient: true
            ) {
              store.send(.saveButtonTapped)
            }
          }
          .overlay(isFocused ? Color.bgDimCard : Color.clear)
        }
        .contentShape(Rectangle())
        .onTapGesture {
          isFocused = false
        }
        .ignoresSafeArea(.keyboard)
        .toolbar(.hidden)
        .background(DesignSystemAsset.background.swiftUIColor)
        
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
      .onAppear {
        if !store.linkURL.isEmpty {
          store.send(.checkURLExists(store.linkURL))
        }
      }
    }}

#Preview {
  AddLinkView(store: Store(initialState: AddLinkFeature.State()) {
    AddLinkFeature()
  })
}
