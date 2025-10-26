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
}
