//
//  Category.swift
//  Domain
//
//  Created by 여성일 on 10/17/25.
//

import Foundation
import SwiftData

@Model
public final class Category {
  @Attribute(.unique) public var categoryName: String // 카테고리 이름
  public var createdAt: Date
  
  @Relationship(inverse: \LinkItem.category) public var links: [LinkItem] = []
  
  public init(categoryName: String) {
    self.categoryName = categoryName
    self.createdAt = Date()
  }
}
