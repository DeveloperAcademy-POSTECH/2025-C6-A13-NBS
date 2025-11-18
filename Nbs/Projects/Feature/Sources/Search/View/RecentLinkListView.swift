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
        .padding(.horizontal, 4)
      
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack(spacing: 10) {
          ForEach(store.recentLinkItem) { item in
            Button {
              store.send(.recentLinkTapped(item))
            } label: {
              ArticleCard(
                title: item.title,
                categoryName: item.category?.categoryName ?? "전체",
                imageURL: item.imageURL ?? "notImage",
                dateString: item.createAt.formattedKoreanDate(),
                newsCompany: item.newsCompany ?? ""
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
