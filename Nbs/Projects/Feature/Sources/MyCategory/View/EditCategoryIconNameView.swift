//
//  EditCategoryIconName.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct EditCategoryIconNameView {
  @Bindable var store: StoreOf<EditCategoryIconNameFeature>
  
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
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(DesignSystemAsset.n0.swiftUIColor)
          .stroke(Color.divider1, lineWidth: 1)
      )
      .padding(.top, 8)
      .padding(.horizontal, 20)

      ScrollView {
        LazyVGrid(columns: columns, spacing: 10) {
          ForEach(0..<15, id: \.self) { index in
            Button {
//              store.selectedIcon = .init(number: index + 1)
            } label: {
              RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.2))
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                  Image(uiImage: DesignSystemAsset.categoryIcon1.image)
                    .resizable()
                    .frame(width: 45, height: 55)
                )
            }
            .buttonStyle(.plain)
          }
        }
        .padding(.horizontal, 20)
      }

      MainButton(
        "완료",
//        isDisabled: store.selectedCategory == nil
      ) {
        store.send(.compeleteButtonTapped)
      }
      .padding(.horizontal, 20)
    }
    .background(DesignSystemAsset.background.swiftUIColor)
    .toolbar(.hidden)
  }
}
