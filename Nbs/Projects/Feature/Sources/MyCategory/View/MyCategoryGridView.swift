//
//  MyCategoryGridView.swift
//  Feature
//
//  Created by 홍 on 10/31/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct MyCategoryGridView {
  let store: StoreOf<MyCategoryGridFeature>
  private let gridItems: [GridItem] = [
    .init(.flexible(), spacing: 10),
    .init(.flexible(), spacing: 10)
  ]
}

extension MyCategoryGridView: View {
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        LazyVGrid(columns: gridItems, spacing: 10) {
          ForEach(viewStore.categories.reversed()) { category in
            Button {
              store.send(.categoryTapped(category))
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
                    .foregroundStyle(.caption2)
                  Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                .padding(.horizontal)
                DesignSystemAsset.primaryCategoryIcon(number: category.icon.number)
                  .resizable()
                  .frame(width: 52, height: 52)
                  .padding(.trailing, 14)
                  .padding(.bottom, 12)
              }
              .frame(maxWidth: .infinity, minHeight: 116)
              .background(.n0)
              .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .shadow(color: .bgShadow3, radius: 4, x: 0, y: 0)
          }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
        .onAppear {
          viewStore.send(.onAppear)
        }
      }
      .scrollDisabled(viewStore.categories.count < 7)
      .scrollIndicators(.hidden)
    }
  }
}
