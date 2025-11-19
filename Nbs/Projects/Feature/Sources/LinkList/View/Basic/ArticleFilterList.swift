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
  @Bindable var store: StoreOf<ArticleFilterFeature>
}

// MARK: - Body
extension ArticleFilterList: View {
  var body: some View {
    ZStack {
      Color.background
        .ignoresSafeArea()
      VStack(spacing: .zero) {
        
        infoContents
          .padding(.bottom, 16)
        articleList
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 66)
    }
  }
  
  private var infoContents: some View {
    HStack(spacing: .zero) {
      HStack(spacing: 0) {
        Text("총 ")
          .font(.B1_M)
          .foregroundStyle(.caption1)
        
        Text("\(store.link.count)")
          .font(.B1_SB)
          .foregroundStyle(.caption1)
        
        Text("개")
          .font(.B1_M)
          .foregroundStyle(.caption1)
      }
      Spacer()
      
      buttonContents
    }
    .padding(.leading, 4)
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
          .padding(.horizontal, 4)
      }
      .frame(height: 32)
      
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
          .padding(.horizontal, 4)
      }
      .frame(height: 32)
    }
  }
  
  @ViewBuilder
  private var articleList: some View {
    if store.link.isEmpty {
      EmptyLinkView()
        .padding(.top, 120)

    } else {
      ForEach(store.link) { article in
        ArticleRowView(article: article, store: store)
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
