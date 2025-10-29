//
//  Icon.swift
//  DesignSystem
//
//  Created by 홍 on 10/16/25.
//

import SwiftUI

public enum Icon {}

///Image(icon: Icon.search) 으로 사용하기
public extension Icon {
  static let chevronLeft = "chevron-left"
  static let chevronRight = "chevron-right"
  static let arrowUp = "arrow-up"
  static let plus = "plus"
  static let x = "x"
  static let search = "search"
  static let settings = "settings"
  static let moreVertical = "more-vertical"
  static let move = "move"
  static let trash = "trash-2"
  static let share = "share"
  static let edit = "edit"
  static let calendar = "calendar"
  static let book = "book"
  static let tag = "tag"
  static let check = "check"
  static let alertCircle = "alert-circle"
  static let helpCircle = "help-circle"
  static let info = "info"
  static let heart = "heart"
  static let smallxCircleFilled = "small-x-circle-filled"
  static let smallChevronRight = "small-chevron-right"
  static let smallChevronDown = "small-chevron-down"
  static let smallPlus = "small-plus"
  static let circlePlus = "circlePlus"
  static let badgeCheck = "badge-check"
}

public extension Image {
  init(icon name: String) {
    self.init(name, bundle: .module)
  }
}
