//
//  MockHighlightItem.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import Foundation
import Domain

/// SwiftData 없이 View에서 미리보기용으로 사용하는 Mock 데이터 모델
struct MockHighlightItem: Identifiable {
  let id: String
  let sentence: String
  let type: String
  let createdAt: Date
  let comments: [Comment]
  
  init(id: String = UUID().uuidString,
       sentence: String,
       type: String,
       createdAt: Date = .now,
       comments: [Comment] = []) {
    self.id = id
    self.sentence = sentence
    self.type = type
    self.createdAt = createdAt
    self.comments = comments
  }
}

extension MockHighlightItem {
  static let mockData: [MockHighlightItem] = [
    MockHighlightItem(
      sentence: "국내 산업 현장 곳곳에서 로봇 활용이 빠르게 늘고 있지만, 정작 로봇을 움직이는 핵심 부품 대부분은 여전히 외국산에 의존하는 것으로 나타났는데 미래 산업으로 꼽히는 로봇의 부품들을 일본과 중국에서 조달하면서 우리 산업의 경쟁력이 하락할 것이라는 우려가 나온다.",
      type: "What",
      comments: [
        Comment(id: 1, type: "What", text: "우리나라 로봇 핵심 부품 해외 의존 중 -> 일본과 중국에서 조달 중임"),
        Comment(id: 2, type: "Detail", text: "AI가 사회 변화에 미치는 영향 강조")
      ]
    ),
    MockHighlightItem(
      sentence: "로봇의 수요는 급격히 증가하고 있지만, 세부 부품은 대부분 해외에서 조달하는 상황인 셈이다.",
      type: "Why",
      comments: [
        Comment(id: 3, type: "Why", text: "해외에서 조달 중"),
        Comment(id: 4, type: "Detail", text: "긍정적·부정적 영향 모두 포함")
      ]
    ),
    MockHighlightItem(
      sentence: "공급망 규모가 작다 보니 대량 조달이 어려워 부품 가격을 줄일 수 없기 때문이다.",
      type: "Detail",
      comments: [
        Comment(id: 5, type: "Detail", text: "대량 생산을 안해서 부품 가격 네고 불가")
      ]
    )
  ]
}
