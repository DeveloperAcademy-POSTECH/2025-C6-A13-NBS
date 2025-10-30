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
              viewStore.send(.toggleCategorySelection(category))
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
                .padding(.top)
                .padding(.leading)
                DesignSystemAsset.primaryCategoryIcon(number: category.icon.number)
                  .resizable()
                  .frame(width: 56, height: 56)
                  .padding(.trailing, 12)
                  .padding(.bottom, 12)
              }
              .frame(maxWidth: .infinity, minHeight: 116)
              .background(
                viewStore.selectedCategories.contains(category)
                ? .bl1
                : .n0
              )
              .clipShape(RoundedRectangle(cornerRadius: 12))
              .overlay(
                RoundedRectangle(cornerRadius: 12)
                  .strokeBorder(viewStore.selectedCategories.contains(category) ? .bl6 : Color.clear, lineWidth: 1.25)
              )
            }
            .buttonStyle(.plain)
            .shadow(color: .bgShadow3, radius: 4, x: 0, y: 0)
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
