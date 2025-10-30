//
//  Icon+.swift
//  DesignSystem
//
//  Created by 홍 on 10/22/25.
//

import SwiftUI

public extension DesignSystemAsset {
  static func categoryIcon(number: Int) -> Image {
    switch number {
    case 1: return DesignSystemAsset.categoryIcon1.swiftUIImage
    case 2: return DesignSystemAsset.categoryIcon2.swiftUIImage
    case 3: return DesignSystemAsset.categoryIcon3.swiftUIImage
    case 4: return DesignSystemAsset.categoryIcon4.swiftUIImage
    case 5: return DesignSystemAsset.categoryIcon5.swiftUIImage
    case 6: return DesignSystemAsset.categoryIcon6.swiftUIImage
    case 7: return DesignSystemAsset.categoryIcon7.swiftUIImage
    case 8: return DesignSystemAsset.categoryIcon8.swiftUIImage
    case 9: return DesignSystemAsset.categoryIcon9.swiftUIImage
    case 10: return DesignSystemAsset.categoryIcon10.swiftUIImage
    case 11: return DesignSystemAsset.categoryIcon11.swiftUIImage
    case 12: return DesignSystemAsset.categoryIcon12.swiftUIImage
    case 13: return DesignSystemAsset.categoryIcon13.swiftUIImage
    case 14: return DesignSystemAsset.categoryIcon14.swiftUIImage
    case 15: return DesignSystemAsset.categoryIcon15.swiftUIImage
    case 16: return DesignSystemAsset.categoryIcon16.swiftUIImage
    default: return DesignSystemAsset.categoryIcon1.swiftUIImage
    }
  }
}

public extension DesignSystemAsset {
  static func primaryCategoryIcon(number: Int) -> Image {
    switch number {
    case 1: return DesignSystemAsset.primaryCategoryIcon1.swiftUIImage
    case 2: return DesignSystemAsset.primaryCategoryIcon2.swiftUIImage
    case 3: return DesignSystemAsset.primaryCategoryIcon3.swiftUIImage
    case 4: return DesignSystemAsset.primaryCategoryIcon4.swiftUIImage
    case 5: return DesignSystemAsset.primaryCategoryIcon5.swiftUIImage
    case 6: return DesignSystemAsset.primaryCategoryIcon6.swiftUIImage
    case 7: return DesignSystemAsset.primaryCategoryIcon7.swiftUIImage
    case 8: return DesignSystemAsset.primaryCategoryIcon8.swiftUIImage
    case 9: return DesignSystemAsset.primaryCategoryIcon9.swiftUIImage
    case 10: return DesignSystemAsset.primaryCategoryIcon10.swiftUIImage
    case 11: return DesignSystemAsset.primaryCategoryIcon11.swiftUIImage
    case 12: return DesignSystemAsset.primaryCategoryIcon12.swiftUIImage
    case 13: return DesignSystemAsset.primaryCategoryIcon13.swiftUIImage
    case 14: return DesignSystemAsset.primaryCategoryIcon14.swiftUIImage
    case 15: return DesignSystemAsset.primaryCategoryIcon15.swiftUIImage
    case 16: return DesignSystemAsset.primaryCategoryIcon16.swiftUIImage
    default: return DesignSystemAsset.primaryCategoryIcon15.swiftUIImage
    }
  }
}
