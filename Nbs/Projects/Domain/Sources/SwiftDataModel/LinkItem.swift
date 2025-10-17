//
//  LinkItem.swift
//  Domain
//
//  Created by 여성일 on 10/16/25.
//

import Foundation
import SwiftData

@Model
public final class LinkItem {
  @Attribute(.unique) public var id: String
  public var urlString: String // URL
  public var title: String // 기사 제목
  public var createAt: Date // 링크 저장 날짜
  public var category: Category?
  public var userMemo: String = "" // 추가 메모
  @Relationship(deleteRule: .cascade) public var highlights: [HighlightItem] = [] // 해당 링크에 연결 된 하이라이트
  
  public init(
    urlString: String,
    title: String
  ) {
    self.id = UUID().uuidString
    self.urlString = urlString
    self.title = title
    self.createAt = Date()
  }
}
