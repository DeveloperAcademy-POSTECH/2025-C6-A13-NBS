//
//  MyCategoryCollection.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct MyCategoryCollectionView {
  @Bindable var store: StoreOf<MyCategoryCollectionFeature>
}

extension MyCategoryCollectionView: View {
  var body: some View {
    ZStack {
      VStack {
        TopAppBarDefaultNoSearchView(
          store: store.scope(
            state: \.topAppBar,
            action: \.topAppBar
          )
        )
        Button {
          print("")
        } label: {
          HStack {
            Text("전체")
              .font(.B1_SB)
              .foregroundStyle(.text1)
            Spacer()
            Image(icon: Icon.chevronRight)
              .resizable()
              .renderingMode(.template)
              .frame(width: 24, height: 24)
              .foregroundStyle(.text1)
          }
          .padding(.horizontal)
          .padding(.vertical, 20)
        }
        .frame(height: 64)
        .background(.bl1)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
        .padding(.top, 8)
        CategoryGridView(
          store: store.scope(
            state: \.categoryGrid,
            action: \.categoryGrid
          )
        )
        .padding(.top, 20)
      }
      .background(DesignSystemAsset.background.swiftUIColor)
      .toolbar(.hidden)
      
      if let sheetStore = store.scope(state: \.settingModal, action: \.settingModal) {
        BottomSheetContainerView(onDismiss: {
          store.send(.settingModal(.dismissButtonTapped))
        }) {
          SettingView(store: sheetStore)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .zIndex(1)
      }
    }
  }
}

#Preview {
  MyCategoryCollectionView(
    store: Store(initialState: MyCategoryCollectionFeature.State()) {
      MyCategoryCollectionFeature()
    })
}
