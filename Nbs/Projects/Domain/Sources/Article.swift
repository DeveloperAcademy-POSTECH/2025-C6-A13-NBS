//
//  Article.swift
//  Domain
//
//  Created by 홍 on 10/15/25.
//

import Foundation

import DesignSystem

public struct Article {
  public let id: UUID
  public let url: String?
  public let imageURL: String?
  public let title: String
  public let createAt: Date
  public let newsCompany: String
  
  public init(
    id: UUID,
    url: String?,
    imageURL: String?,
    title: String,
    createAt: Date,
    newsCompany: String
  ) {
    self.id = id
    self.url = url
    self.imageURL = imageURL
    self.title = title
    self.createAt = createAt
    self.newsCompany = newsCompany
  }
}

extension Article: ArticleDisplayable {
  public var dateToString: String {
    DateFormatter.articleDateFormatter.string(from: createAt)
  }
}

extension DateFormatter {
  public static let articleDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 M월 d일"
    return formatter
  }()
}
