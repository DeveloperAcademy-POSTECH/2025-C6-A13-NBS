//
//  ArticleProtocol.swift
//  DesignSystem
//
//  Created by 홍 on 10/15/25.
//

import Foundation

public protocol ArticleDisplayable {
  var id: UUID { get }
  var url: String? { get }
  var imageURL: String? { get }
  var title: String { get }
  var createAt: Date { get }
  var newsCompany: String { get }
  var dateToString: String { get }
}
