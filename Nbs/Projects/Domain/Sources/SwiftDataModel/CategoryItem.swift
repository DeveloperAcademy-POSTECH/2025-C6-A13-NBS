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
public final class CategoryItem: Identifiable, Codable {
  @Attribute(.unique) public var id: UUID
  @Attribute(.unique) public var categoryName: String // 카테고리 이름
  public var createdAt: Date
  public var icon: CategoryIcon
  
  @Relationship(inverse: \LinkItem.category) public var links: [LinkItem] = []
  
  public init(
    categoryName: String,
    icon: CategoryIcon
  ) {
    self.id = UUID()
    self.categoryName = categoryName
    self.createdAt = Date()
    self.icon = icon
  }
  
  enum CodingKeys: CodingKey {
    case id, categoryName, createAt, icon
  }
  
  public required init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(UUID.self, forKey: .id)
    self.categoryName = try container.decode(String.self, forKey: .categoryName)
    self.createdAt = try container.decode(Date.self, forKey: .createAt)
    self.icon = try container.decode(CategoryIcon.self, forKey: .icon)
  }
  
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(categoryName, forKey: .categoryName)
    try container.encode(createdAt, forKey: .createAt)
    try container.encode(icon, forKey: .icon)
  }
}
