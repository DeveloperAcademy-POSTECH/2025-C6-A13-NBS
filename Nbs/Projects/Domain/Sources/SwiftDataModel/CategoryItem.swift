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
public final class CategoryItem {
  @Attribute(.unique) public var categoryName: String // 카테고리 이름
  public var createdAt: Date
  public var icon: CategoryIcon
  
  @Relationship(inverse: \LinkItem.category) public var links: [LinkItem] = []
  
  public init(
    categoryName: String,
    icon: CategoryIcon
  ) {
    self.categoryName = categoryName
    self.createdAt = Date()
    self.icon = icon
  }
}
