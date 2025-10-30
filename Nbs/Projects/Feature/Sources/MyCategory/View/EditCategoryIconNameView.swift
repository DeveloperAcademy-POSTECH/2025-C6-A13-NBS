
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
      Text("카테고리명")
        .font(.B2_SB)
        .foregroundStyle(.caption1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 24)
        .padding(.top, 8)
      
      TextField(
        "카테고리명을 입력해주세요",
        text: $store.categoryName.sending(\.setCategoryName)
      )
      .focused($isFocused)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(DesignSystemAsset.n0.swiftUIColor)
          .stroke(Color.divider1, lineWidth: 1)
      )
      .padding(.top, 8)
      .padding(.horizontal, 20)
      
      Text("카테고리 아이콘")
        .font(.B2_SB)
        .foregroundStyle(.caption1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 24)
        .padding(.top, 24)
      
      ScrollView {
        LazyVGrid(columns: columns, spacing: 10) {
          ForEach(1..<16, id: \.self) { index in
            let icon = CategoryIcon(number: index)
            Button {
              store.send(.selectIcon(icon))
            } label: {
              RoundedRectangle(cornerRadius: 12)
                .fill(
                  store.selectedIcon == icon
                  ? .bl1
                  : .clear
                )
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                  DesignSystemAsset.primaryCategoryIcon(number: index)
                    .resizable()
                    .frame(width: 45, height: 45)
                )
                .overlay(
                  RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(store.selectedIcon == icon ? .bl6 : Color.clear, lineWidth: 1.25)
                )
            }
            .buttonStyle(.plain)
            .disabled(isFocused)
          }
        }
        .padding(.horizontal, 20)
      }
      .scrollDisabled(isFocused)
      
      MainButton(
        "완료",
        isDisabled: store.categoryName.isEmpty
      ) {
        store.send(.compeleteButtonTapped)
      }
      .padding(.horizontal, 20)
    }
    .background(DesignSystemAsset.background.swiftUIColor)
    .onTapGesture {
      isFocused = false
    }
    .toolbar(.hidden)
    .ignoresSafeArea(.keyboard)
  }
}
