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
        style: .default,
        placeholder: "링크를 입력해주세요",
        header: "추가할 링크"
      )
            
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
        isDisabled: store.linkURL.isEmpty
      ) {
        store.send(.saveButtonTapped)
      }
      .padding(.horizontal, 20)
    }
    .ignoresSafeArea(.keyboard)
    .navigationBarHidden(true)
    .background(DesignSystemAsset.background.swiftUIColor)
        .alert($store.scope(state: \.alert, action: \.alert))
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
