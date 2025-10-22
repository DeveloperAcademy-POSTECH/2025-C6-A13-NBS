//
//  ArticleFilterList.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

/// 링크 리스트의 하단 필터링 된 기사리스트
struct ArticleFilterList {
  let store: StoreOf<ArticleFilterFeature>
}

// MARK: - Body
extension ArticleFilterList: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 12) {
        infoContents
        articleList
      }
    }
    .padding(.horizontal, 20)
  }
  
  private var infoContents: some View {
    HStack(spacing: .zero) {
      HStack(spacing: 0) {
            Text("총 ")
              .font(.B1_M)
              .foregroundStyle(.caption1)

            Text("\(store.articles.count)")
              .font(.B1_SB)
              .foregroundStyle(.caption1)

            Text("개")
              .font(.B1_M)
              .foregroundStyle(.caption1)
          }
      Spacer()
      
      buttonContents
    }
  }
  
  private var buttonContents: some View {
    HStack(spacing: 5) {
      Button {
        store.send(.sortOrderChanged(.oldest))
      } label: {
        Text("오래된순")
          .font(store.sortOrder == .oldest ? .B2_M : .C2)
          .foregroundStyle(
            store.sortOrder == .oldest ? .caption1 : .caption2
          )
      }
      
      Rectangle()
        .fill(.divider2)
        .frame(width: 1, height: 15)
      
      Button {
        store.send(.sortOrderChanged(.latest))
      } label: {
        Text("최신순")
          .font(store.sortOrder == .latest ? .B2_M : .C2)
          .foregroundStyle(
            store.sortOrder == .latest ? .caption1 : .caption2
          )
      }
    }
  }
  
  private var articleList: some View {
    ForEach(store.state.articles) { article in
      Button {
        store.send(.listCellTapped(article))
      } label: {
        ArticleCard(
          title: article.title,
          categoryName: article.category?.categoryName,
          imageURL: article.imageURL ?? "photo",
          dateString: article.createAt.formatted(date: .numeric, time: .omitted)
        )
        .simultaneousGesture(
          LongPressGesture().onEnded { _ in
            store.send(.listCellLongPressed(article))
          }
        )
      }
    }
  }
}

#Preview {
  ArticleFilterList(
    store: Store(initialState: ArticleFilterFeature.State()) {
      ArticleFilterFeature()
    }
  )
}
