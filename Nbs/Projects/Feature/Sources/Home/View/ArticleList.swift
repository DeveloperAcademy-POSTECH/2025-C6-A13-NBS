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
    VStack(spacing: 8) {
      ScrollViewHeader(
        headerTitle: .recentAddLink,
        buttonTitle: .showMore,
        showButton: !store.articles.isEmpty) {
          store.send(.moreLinkButtonTapped)
        }
      
      if store.state.articles.isEmpty {
        if store.state.showTipCard {
          TipCardView {
            store.send(.tipCardTapped)
          } closeTap: {
            store.send(.toggleTipCard)
          }
          .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
          EmptyArticleCard(type: .noLinks)
            .padding(.top, 120)
        }
      }
      else {
        VStack(spacing: 10) {
          ForEach(store.state.articles.reversed().prefix(5)) { article in
            Button {
              store.send(.listCellTapped(article))
            } label: {
              ArticleCard(
                title: article.title,
                categoryName: article.category?.categoryName ?? "전체",
                imageURL: article.imageURL ?? "notImage",
                dateString: article.createAt.formattedKoreanDate(),
                newsCompany: article.newsCompany ?? ""
              )
              .shadow(color: .bgShadow1, radius: 3, x: 0, y: 2)
              .shadow(color: .bgShadow2, radius: 2, x: 0, y: 2)
            }
            .buttonStyle(.plain)
          }
        }
      }
      
      if store.state.articles.count >= 6 {
        Button {
          store.send(.moreLinkButtonTapped)
        } label: {
          Text(ArticleNameSpace.showAllLink)
            .font(.B1_SB)
            .foregroundStyle(.caption1)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(.n30)
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
