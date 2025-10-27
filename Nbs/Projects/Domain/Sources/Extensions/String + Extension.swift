//
//  String + Extension.swift
//  Domain
//
//  Created by 여성일 on 10/26/25.
//

import Foundation

public extension String {
  /// 문자열이 지정된 길이를 초과하는 경우, 해당 길이까지 자르고 "..."을 추가하여 반환합니다.
  ///
  /// - Parameter count: 문자열을 자를 최대 길이
  /// - Returns: 지정된 길이로 자른 문자열이나 원본 문자열 (String)
  func truncatedString(count: Int) -> String {
    if self.count > count {
      return String(self.prefix(count)) + "..."
    } else {
      return self
    }
  }
  
  /// HTML 엔티티를 디코딩하는 메소드
  ///
  /// 예시: '&quot'; -> "
  /// - Returns: HTML 엔티티가 디코딩된 문자열.
  func decodeHtmlEntities() -> String {
    guard let data = self.data(using: .utf8) else { return self }
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ]
    guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return self }
    return attributedString.string
  }
}
