//
//  ArticleProtocol.swift
//  DesignSystem
//
//  Created by 홍 on 10/15/25.
//

import Foundation

public protocol ArticleDisplayable {
  var title: String { get }
  var imageURL: URL? { get }
  var date: Date { get }
  var newsCompany: String { get }
}
