//
//  CategoryGridView.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct CategoryGridView {
  let store: StoreOf<CategoryGridFeature>
  private let gridItems: [GridItem] = [
    .init(.flexible(), spacing: 10),
    .init(.flexible(), spacing: 10)
  ]
}

extension CategoryGridView: View {
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        LazyVGrid(columns: gridItems, spacing: 10) {
          ForEach(viewStore.categories) { category in
            Button {
              print("")
            } label: {
              ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 4) {
                  Text(category.categoryName)
                    .font(.B1_SB)
                    .foregroundStyle(.text1)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                  Text("\(category.links.count)개")
                    .font(.B2_M)
                    .foregroundStyle(.caption1)
                  Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                .padding(.leading, 16)
                Image(uiImage: DesignSystemAsset.emptyImage.image)
                  .resizable()
                  .frame(width: 56, height: 56)
                  .padding(.trailing, 12)
                  .padding(.bottom, 12)
              }
              .frame(maxWidth: .infinity, minHeight: 116)
              .background(Color.blue)
              .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
          }
        }
        .padding(.horizontal, 20)
        .onAppear {
          viewStore.send(.onAppear)
        }
      }
      .scrollDisabled(viewStore.categories.count < 7)
    }
  }
}
