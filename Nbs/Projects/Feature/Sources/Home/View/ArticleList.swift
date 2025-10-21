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
      
      ForEach(store.state.articles.suffix(5)) { article in
        Button {
          store.send(.listCellTapped(article))
        } label: {
          ArticleCard(
            title: article.title,
            categoryName: article.category?.categoryName,
            imageURL: article.imageURL ?? "placeholder_image",
            dateString: article.createAt.formatted(date: .numeric, time: .omitted)
          )
          .background(.n0)
          .clipShape(RoundedRectangle(cornerRadius: 12))
        }
      }
      
      if store.state.articles.count >= 6 {
        Button {
        } label: {
          Text(ArticleNameSpace.showAllLink)
            .font(.B1_SB)
            .foregroundStyle(.bl6)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(.bl1)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
      }
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  ArticleListView(
    store: Store(initialState: ArticleListFeature.State()) {
      ArticleListFeature()
    }
  )
}
