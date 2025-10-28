//
//  Category.swift
//  Domain
//
//  Created by 여성일 on 10/17/25.
//

import Foundation
import SwiftData

public struct CategoryIcon: Codable, Hashable {
  public let number: Int
  
  public init(number: Int = 1) {
    self.number = number
  }
  
  public var name: String {
    "CateogryIcon\(self.number)"
  }
}

@Model
public final class CategoryItem: Identifiable, Codable, Equatable {
  @Attribute(.unique) public var id: UUID
  @Attribute(.unique) public var categoryName: String // 카테고리 이름
  public var createdAt: Date
  public var icon: CategoryIcon
  
  @Relationship(inverse: \ArticleItem.category) public var links: [ArticleItem] = []
  
  public init(
    categoryName: String,
    icon: CategoryIcon
  ) {
    self.id = UUID()
    self.categoryName = categoryName
    self.createdAt = Date()
    self.icon = icon
  }
  
  enum CodingKeys: String, CodingKey {
    case id, categoryName, createdAt, icon
  }
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(UUID.self, forKey: .id)
    self.categoryName = try container.decode(String.self, forKey: .categoryName)
    self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    self.icon = try container.decode(CategoryIcon.self, forKey: .icon)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(categoryName, forKey: .categoryName)
    try container.encode(createdAt, forKey: .createdAt)
    try container.encode(icon, forKey: .icon)
  }
}
