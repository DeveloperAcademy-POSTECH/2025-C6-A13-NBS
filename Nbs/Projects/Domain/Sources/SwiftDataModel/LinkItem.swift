//
//  LinkItem.swift
//  Domain
//
//  Created by 여성일 on 10/16/25.
//

import Foundation
import SwiftData

@Model
public final class ArticleItem {
  @Attribute(.unique) public var id: String
  @Attribute(.unique) public var urlString: String // URL
  public var title: String // 기사 제목
  public var createAt: Date // 링크 저장 날짜
  public var lastViewedDate: Date // 마지막으로 본 날짜
  public var category: CategoryItem?
  public var userMemo: String = "" // 추가 메모
  public var imageURL: String? // 이미지 URL
  public var newsCompany: String? // 신문사
  @Relationship(deleteRule: .cascade) public var highlights: [HighlightItem] = [] // 해당 링크에 연결 된 하이라이트
  
  public init(
    urlString: String,
    title: String,
    lastViewedDate: Date = Date(),
    imageURL: String? = nil,
    newsCompany: String? = nil
  ) {
    self.id = UUID().uuidString
    self.urlString = urlString
    self.title = title
    self.createAt = Date()
    self.lastViewedDate = lastViewedDate
    self.imageURL = imageURL
    self.newsCompany = newsCompany
  }
  
  enum CodingKeys: CodingKey {
    case id, urlString, title, createAt, lastViewedDate, userMemo, imageURL, newsCompany, category, highlights
  }
  
  public required init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.urlString = try container.decode(String.self, forKey: .urlString)
    self.title = try container.decode(String.self, forKey: .title)
    self.createAt = try container.decode(Date.self, forKey: .createAt)
    self.lastViewedDate = try container.decode(Date.self, forKey: .lastViewedDate)
    self.userMemo = try container.decode(String.self, forKey: .userMemo)
    self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
    self.newsCompany = try container.decodeIfPresent(String.self, forKey: .newsCompany)
    self.category = try container.decodeIfPresent(CategoryItem.self, forKey: .category)
    self.highlights = try container.decode([HighlightItem].self, forKey: .highlights)
  }
  
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(urlString, forKey: .urlString)
    try container.encode(title, forKey: .title)
    try container.encode(createAt, forKey: .createAt)
    try container.encode(lastViewedDate, forKey: .lastViewedDate)
    try container.encode(userMemo, forKey: .userMemo)
    try container.encodeIfPresent(imageURL, forKey: .imageURL)
    try container.encodeIfPresent(newsCompany, forKey: .newsCompany)
    try container.encodeIfPresent(category, forKey: .category)
    try container.encode(highlights, forKey: .highlights)
  }
}
