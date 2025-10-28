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
  public var urlString: String // URL
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
    self.lastViewedDate = lastViewedDate // ⭐️ 초기화
    self.imageURL = imageURL
    self.newsCompany = newsCompany
  }
}
