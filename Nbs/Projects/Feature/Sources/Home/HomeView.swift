//
//  HomeView.swift
//  Feature
//
//  Created by 홍 on 10/15/25.
//

import SwiftUI

import Domain

public struct HomeView {
  public init() {}
}

extension HomeView: View {
  public var body: some View {
    List {
      Section {
        HStack {
          Text("최근 추가한 링크")
          Text("더보기")
        }
      }
      
      Section {
        ArticleCard(
          article: Article(
            id: UUID(),
            url: nil,
            imageURL: nil,
            title: "하이",
            createAt: .now,
            newsCompany: "동아일보"
          )
        )
      } header: {
        HStack(spacing: 0) {
          Text("최근 추가한 링크")
            .font(.B1_SB)
            .foregroundStyle(.caption1)
          Spacer()
          Text("더보기")
            .font(.B2_M)
            .foregroundStyle(.caption1)
        }
      }
    }
  }
}

#Preview {
  HomeView()
}
