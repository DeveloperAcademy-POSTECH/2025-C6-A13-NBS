//
//  ArticleCategory.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import Foundation

public struct ArticleCategory: Identifiable, Hashable {
  public let id = UUID()
  public let name: String
  
  public init(name: String) {
    self.name = name
  }
  
  public static let mock: [ArticleCategory] = [
    .init(name: "전체"),
    .init(name: "정치"),
    .init(name: "경제"),
    .init(name: "사회"),
    .init(name: "IT/과학"),
    .init(name: "스포츠")
  ]
}