//
//  CopiedLink.swift
//  Domain
//
//  Created by 홍 on 10/30/25.
//

public struct CopiedLink: Codable {
  public let url: String
  
  public init(url: String) {
    self.url = url
  }
}
