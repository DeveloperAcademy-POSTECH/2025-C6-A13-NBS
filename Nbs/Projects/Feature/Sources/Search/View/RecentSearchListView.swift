//
//  RecentSearchListView.swift
//  Feature
//
//  Created by 여성일 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture

//MARK: - Properties
struct RecentSearchListView: View {
  let store: StoreOf<RecentSearchFeature>
}

//MARK: - View
extension RecentSearchListView {
  var body: some View {
    VStack(spacing: 16) {
      HStack {
        Text("최근 검색어")
          .font(.B2_SB)
          .foregroundStyle(.caption2)
        Spacer()
        Button {
          store.send(.clear)
        } label: {
          Text("전체삭제")
            .font(.B2_M)
            .foregroundStyle(.caption2)
        }
        .buttonStyle(.plain)
      }
      .padding(.horizontal, 20)
      
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
        .padding(.leading, 20)
      }
      .frame(height: 40)
    }
    .onAppear {
      store.send(.onAppear)
    }
    .padding(.vertical, 8)
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
