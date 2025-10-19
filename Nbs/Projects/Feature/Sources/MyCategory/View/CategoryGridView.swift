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
      LazyVGrid(columns: gridItems, spacing: 10) {
        ForEach(viewStore.categories) { category in
          Button {
            print("")
          } label: {
            Text(category.categoryName)
              .font(.B1_SB)
              .foregroundStyle(.text1)
              .frame(maxWidth: .infinity, minHeight: 50)
              .background(Color.brown)
              .cornerRadius(10)
          }
        }
      }
      .padding(.horizontal, 20)
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}
