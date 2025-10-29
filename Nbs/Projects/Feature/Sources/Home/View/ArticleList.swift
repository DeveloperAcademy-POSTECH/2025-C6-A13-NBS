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
            //TODO: 네비게이션 연결
            print("")
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
        VStack(spacing: 8) {
          ForEach(store.state.articles.reversed().prefix(5)) { article in
            Button {
              store.send(.listCellTapped(article))
            } label: {
              LinkCard(
                title: article.title,
                newsCompany: article.newsCompany ?? "네이버 뉴스",
                image: article.imageURL ?? "placeholder_image",
                date: article.createAt.formattedKoreanDate()
              )
              .background(.n0)
              .clipShape(RoundedRectangle(cornerRadius: 12))
              .padding(.vertical, 1)
              .shadow(color: .bgShadow1, radius: 3, x: 0, y: 2)
              .shadow(color: .bgShadow2, radius: 2, x: 0, y: 2)
            }
          }
        }
      }
      
      if store.state.articles.count >= 6 {
        Button {
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
