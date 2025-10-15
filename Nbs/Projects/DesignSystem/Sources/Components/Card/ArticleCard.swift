//
//  ArticleCard.swift
//  DesignSystem
//
//  Created by 홍 on 10/15/25.
//

import SwiftUI

public struct ArticleCard<T: ArticleDisplayable> {
  public let article: T
  public init(article: T) { self.article = article }
}

extension ArticleCard: View {
  public var body: some View {
    VStack {
      AsyncImage(url: article.imageURL)
      Text(article.title)
      Text("\(article.date)")
    }
  }
}

//#Preview {
//  struct MockArticle: ArticleDisplayable {
//    let title = "SwiftUI 프로토콜 카드 예시"
//    let imageURL = URL(string: "https://picsum.photos/300/200")
//    let date = Date()
//    var dateText: String { "2025년 10월 15일" }
//  }
//  
//  ArticleCard(article: MockArticle())
//    .padding()
//    .previewLayout(.sizeThatFits)
//}
