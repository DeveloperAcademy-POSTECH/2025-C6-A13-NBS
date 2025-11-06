//
//  PolicyDetailParameter.swift
//  Domain
//
//  Created by 이안 on 11/6/25.
//

import Foundation

public struct PolicyDetailParameter: Codable, Equatable {
  public let title: String
  public let text: String
  
  public init(title: String, text: String) {
    self.title = title
    self.text = text
  }
}
