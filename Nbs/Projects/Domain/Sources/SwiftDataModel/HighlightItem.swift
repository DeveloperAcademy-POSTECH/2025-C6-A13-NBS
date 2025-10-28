//
//  HighlightItem.swift
//  Domain
//
//  Created by 여성일 on 10/16/25.
//

import Foundation
import SwiftData

public struct Comment: Codable, Hashable {
    public let id: Double // 메모를 구분하기 위한 고유 ID
    public let type: String // 메모의 종류 (What/Why/Detail)
    public let text: String // 코멘트 내용
    
    public init(id: Double, type: String, text: String) {
        self.id = id
        self.type = type
        self.text = text
    }
}

@Model
public final class HighlightItem {
  @Attribute(.unique) public var id: String
  public var sentence: String // 하이라이팅 문장
  public var type: String // 하이라이팅 타입 (What/Why/Detail)
  public var createdAt: Date // 하이라이트 생성 날짜
  
  @Attribute(originalName: "comments_json") private var commentsJSON: String = "[]" // JSON Comment
  
  // 하이라이팅 문장의 코멘트
  public var comments: [Comment] {
    get {
      guard let data = commentsJSON.data(using: .utf8),
            let decodedComments = try? JSONDecoder().decode([Comment].self, from: data) else {
        return []
      }
      return decodedComments
    }
    set {
      guard let data = try? JSONEncoder().encode(newValue),
            let jsonString = String(data: data, encoding: .utf8) else {
        commentsJSON = "[]"
        return
      }
      commentsJSON = jsonString
    }
  }
  
  public var link: ArticleItem? // 어떤 linkItem에 속해있는지 구분을 위한 구분자
  
  public init(
    id: String,
    sentence: String,
    type: String,
    createdAt: Date,
    comments: [Comment] = []
  ) {
    self.id = id
    self.sentence = sentence
    self.type = type
    self.createdAt = createdAt
    self.comments = comments
  }
}
