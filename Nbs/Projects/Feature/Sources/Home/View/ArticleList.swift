//
//  ArticleList.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct ArticleListView {
  let store: StoreOf<ArticleListFeature>
}

extension ArticleListView: View {
  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text(ArticleNameSpace.recentAddLink)
          .font(.B1_SB)
          .foregroundStyle(.caption1)
        Spacer()
        Button {
          store.send(.moreLinkButtonTapped)
        } label: {
          HStack {
            Text(ArticleNameSpace.showMore)
              .font(.B2_M)
              .foregroundStyle(.caption1)
            Image(icon: Icon.smallChevronRight)
              .resizable()
              .frame(width: 20, height: 20)
          }
        }
      }
      
      ForEach(store.articles) { article in
        Button {
          store.send(.listCellTapped)
        } label: {
          ArticleCard(article: article)
        }
      }
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
  ArticleListView(
    store: Store(initialState: ArticleListFeature.State()) {
      ArticleListFeature()
    }
  )
}
