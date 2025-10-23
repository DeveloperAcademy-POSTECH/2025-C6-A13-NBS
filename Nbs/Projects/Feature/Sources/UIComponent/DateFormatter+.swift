//
//  DateFormatter+.swift
//  Feature
//
//  Created by 이안 on 10/22/25.
//

import Foundation

public enum DateFormatter {
  public static let date = Date.FormatStyle()
    .year(.defaultDigits)
    .month(.defaultDigits)
    .day(.defaultDigits)
    .locale(Locale(identifier: "ko_KR"))
}
