//
//  ArticleCard.swift
//  DesignSystem
//
//  Created by 홍 on 10/15/25.
//

import SwiftUI

public struct ArticleCard<Article: ArticleDisplayable> {
  public let article: Article
  public init(article: Article) { self.article = article }
}

extension ArticleCard: View {
  public var body: some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 0) {
        Text(article.title)
          .font(.B1_SB)
        Text(article.newsCompany)
          .font(.B2_M)
          .foregroundStyle(.caption2)
          .padding(.top, 2)
        Text(article.dateToString)
          .font(.B2_M)
          .foregroundStyle(.caption2)
          .padding(.top)
      }
      .padding(.leading)
      Spacer()
      AsyncImage(url: URL(string:article.imageURL!)) { image in
        switch image {
        case .empty:
          AsyncImage(url: URL(string:article.imageURL!))
            .frame(minWidth: 84, maxHeight: 112)
        case .success(let image):
            image
                .resizable()
                .scaledToFill()
                .frame(width: 84, height: 112)
                .clipped()
        case .failure:
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 84, height: 112)
                .foregroundColor(.gray)
                .padding()
        @unknown default:
            EmptyView()
        }
      }
      .padding(.trailing, 10)
    }
  }
}

struct MockArticle: ArticleDisplayable {
  var createAt: Date = .now
  var id: UUID = UUID()
  var url: String? = "https://biz.chosun.com/international/international_economy/2025/10/07/CFQGNTCO7RB7BAXANMSF2MQI7E/"
  var imageURL: String? = "https://biz.chosun.com/resizer/v2/MM7OL3YTWRMVXC3EBKWD5POEN4.jpg?auth=a60354c4bf7aa4822ea553600edebe51289f9bdbb5c2cad8ab16474c8da7e8c8&width=61"
  var title: String = "트럼프 “11월 1일부터 중·대형 트럭에 25% 관세 부과"
  var newsCompany: String = "조선비즈"
  var dateToString: String {
    var components = DateComponents()
    components.year = 2025
    components.month = 10
    components.day = 25
    let date = Calendar.current.date(from: components)!
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 M월 d일"
    return formatter.string(from: date)
  }
}

#Preview {
  ArticleCard(article: MockArticle())
}
