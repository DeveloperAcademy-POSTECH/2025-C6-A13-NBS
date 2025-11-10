//
//  LinkListPayload.swift
//  Domain
//
//  Created by 이안 on 11/10/25.
//

import Foundation

public struct LinkListPayload: Codable, Equatable {
  public let links: [ArticleItem]
  public let categoryName: String
  
  public init(links: [ArticleItem], categoryName: String) {
    self.links = links
    self.categoryName = categoryName
  }
}
