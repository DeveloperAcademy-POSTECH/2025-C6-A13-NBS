//
//  Date + Extension.swift
//  Domain
//
//  Created by 여성일 on 10/21/25.
//

import Foundation

extension Date {
  public func formattedKoreanDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일"
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: self)
  }
}
