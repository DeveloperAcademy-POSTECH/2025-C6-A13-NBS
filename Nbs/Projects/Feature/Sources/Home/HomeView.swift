//
//  HomeView.swift
//  Feature
//
//  Created by 홍 on 10/15/25.
//

import SwiftUI

import Domain
import DesignSystem

public struct HomeView {
  let articles: [MockArticle] = MockArticle.mockArticles
  public init() {}
}

extension HomeView: View {
  public var body: some View {
    List {
      Section {
        HStack {
          Text("최근 추가한 링크")
            .font(.B1_SB)
            .foregroundStyle(.caption1)
        }
      }
      
      Section {
        ForEach(articles) { article in
          ArticleCard(article: article)
        }
      } header: {
        HStack(spacing: 0) {
          Text("최근 추가한 링크")
            .font(.B1_SB)
            .foregroundStyle(.caption1)
          Spacer()
          Text("더보기")
            .font(.B2_M)
            .foregroundStyle(.caption1)
          Image(icon: Icon.smallChevronRight)
            .resizable()
            .frame(width: 20, height: 20)
        }
      }
    }
    .listStyle(.insetGrouped)
  }
}

#Preview {
  HomeView()
}
