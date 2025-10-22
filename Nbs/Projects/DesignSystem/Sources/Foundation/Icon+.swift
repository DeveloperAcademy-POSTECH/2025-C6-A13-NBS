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
    default: return DesignSystemAsset.categoryIcon1.swiftUIImage
    }
  }
}
