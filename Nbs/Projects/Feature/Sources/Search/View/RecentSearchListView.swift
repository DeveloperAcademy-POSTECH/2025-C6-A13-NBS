//
//  RecentSearchListView.swift
//  Feature
//
//  Created by 여성일 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

//MARK: - Properties
struct RecentSearchListView: View {
  let store: StoreOf<RecentSearchFeature>
}

//MARK: - View
extension RecentSearchListView {
  var body: some View {
    VStack(spacing: .zero) {
      HStack {
        Text("최근 검색어")
          .font(.B2_SB)
          .foregroundStyle(.caption2)
        Spacer()
        Button {
          store.send(.clear)
        } label: {
          Text("전체 삭제")
            .font(.B2_M)
            .foregroundStyle(.caption2)
        }
        .buttonStyle(.plain)
        .frame(width: 62, height: 32)
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 16)
      
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 6) {
          ForEach(store.searches) { searchTerm in
            RecentSearchChipButton(
              title: searchTerm.text,
              chipTouchAction: { store.send(.chipTapped(searchTerm.text)) },
              deleteAction: { store.send(.del(id: searchTerm.id)) }
            )
          }
        }
        .padding(.horizontal, 20)
      }
      .frame(height: 40)
    }
    .onAppear {
      store.send(.onAppear)
    }
    .padding(.top, 8)
    .background(Color.background)
  }
}

#Preview {
  RecentSearchListView(
    store: Store(initialState: RecentSearchFeature.State(), reducer: {
      RecentSearchFeature()
    })
  )
}
