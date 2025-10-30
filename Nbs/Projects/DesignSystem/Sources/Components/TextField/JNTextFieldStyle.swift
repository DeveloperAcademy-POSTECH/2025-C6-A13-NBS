//
//  JNTextFieldStyle.swift
//  DesignSystem
//
//  Created by 홍 on 10/30/25.
//

import SwiftUI

public enum JNTextFieldStyle {
  case `default`
  case filled
  case foucsed
  case disabled
  case error
  case errorCaption
  
  var strokeColor: Color {
    switch self {
    case .default, .filled:
      return .divider1
    case .foucsed:
      return .n50
    case .disabled:
      return .n30
    case .error, .errorCaption:
      return .danger
    }
  }
  
  var textColor: Color {
    switch self {
    case .default, .foucsed, .filled, .error, .errorCaption:
      return .text1
    case .disabled:
      return .caption2
    }
  }
  
  var backgroundColor: Color {
    switch self {
    case .foucsed, .filled, .default:
      return .n0
    case .disabled:
      return .n20
    case .error, .errorCaption:
      return .background
    }
  }
}
