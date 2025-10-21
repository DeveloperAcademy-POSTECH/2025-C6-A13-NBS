//
//  RecentLinkListView.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

import Domain
import DesignSystem

// MARK: - Properties
struct RecentLinkListView: View {
  let store: StoreOf<RecentLinkFeature>
}

// MARK: - View
extension RecentLinkListView {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("최근 본 링크")
        .font(.B2_SB)
        .foregroundStyle(.caption2)
      
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack {
          ForEach(store.recentLinkItem) { item in
            Button {
              store.send(.recentLinkTapped(item))
            } label: {
              LinkCard(
                title: item.title,
                newsCompany: "조선 비즈",
                image: "plus",
                date: item.createAt.formattedKoreanDate()
              )
            }
            .buttonStyle(.plain)
          }
        }
      }
    }
    .onAppear{ store.send(.onAppear) }
    .background(Color.background)
    .padding(.horizontal, 20)
  }
}

#Preview {
  RecentLinkListView(
    store: Store(initialState: RecentLinkFeature.State(), reducer: {
    RecentLinkFeature()
  }))
}
