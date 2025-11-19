//
//  OriginalArticlePayload.swift
//  Feature
//
//  Created by 여성일 on 11/6/25.
//

import Domain
import Foundation

//struct OriginalPayload: Codable {
//  let url: String
//  let highlights: [HighlightItem]
//}

struct OriginalPayload: Codable {
  let articleItem: ArticleItem
}
