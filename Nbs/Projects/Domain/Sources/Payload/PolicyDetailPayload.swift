//
//  PolicyDetailPayload.swift
//  Domain
//
//  Created by 이안 on 11/10/25.
//

import Foundation

public struct PolicyDetailPayload: Codable, Equatable {
  public let title: String
  public let text: String
  
  public init(title: String, text: String) {
    self.title = title
    self.text = text
  }
}
