//
//  Font+.swift
//  DesignSystem
//
//  Created by 이안 on 10/14/25.
//

import SwiftUI
import UIKit

// MARK: - TypeStyle

/// 텍스트 스타일 토큰
///
/// `Font`와 함께 줄 간격(line height)과 자간(letter spacing)을 한 번에 적용하기 위한 구조체
///
/// - Note: `lineHeightMultiplier`는 폰트 크기에 대한 배수(예: 1.3 = 130%)
///         `letterSpacingPercent`는 폰트 크기에 대한 퍼센트(예: -0.02 = -2%)
///

// MARK: - TypeStyle
public struct TypeStyle {
  public let font: Font          // SwiftUI 폰트 (Pretendard)
  public let uiFont: UIFont      // 실제 UIKit 폰트
  public let size: CGFloat       // 폰트 사이즈
  public let lineHeight: CGFloat // Figma 기준 배수 (ex. 1.5)
  public let letterSpacing: CGFloat // 퍼센트 (-0.02 = -2%)

  public init(
    font: Font,
    uiFont: UIFont,
    size: CGFloat,
    lineHeight: CGFloat,
    letterSpacing: CGFloat
  ) {
    self.font = font
    self.uiFont = uiFont
    self.size = size
    self.lineHeight = lineHeight
    self.letterSpacing = letterSpacing
  }

  /// Figma lineHeight(배수) → 실제 pt 기반 추가 여백 계산
  public var extraSpacing: CGFloat {
    max((size * lineHeight) - uiFont.lineHeight, 0)
  }

  /// Figma 퍼센트(letterSpacing) → pt 보정
  public var letterSpacingPx: CGFloat {
    letterSpacing * size
  }
}

// MARK: - Pretendard 연결
public extension Font {
  enum Pretendard {
    case semibold, bold, regular, medium

    var convertible: DesignSystemFontConvertible {
      switch self {
      case .semibold: DesignSystemFontFamily.Pretendard.semiBold
      case .bold: DesignSystemFontFamily.Pretendard.bold
      case .regular: DesignSystemFontFamily.Pretendard.regular
      case .medium: DesignSystemFontFamily.Pretendard.medium
      }
    }

    func font(size: CGFloat) -> UIFont {
      convertible.font(size: size)
    }

    func swiftUIFont(size: CGFloat) -> Font {
      convertible.swiftUIFont(size: size)
    }
  }
}

// MARK: - UIView 폰트 변환 헬퍼
private extension UIFont {
  static func pretendard(type: Font.Pretendard, size: CGFloat) -> UIFont {
    type.font(size: size)
  }
}

// MARK: - View Modifier
public extension View {
  func font(_ style: TypeStyle) -> some View {
    self
      .font(style.font)
      .kerning(style.letterSpacingPx)
      .lineSpacing(style.extraSpacing)
      .padding(.vertical, style.extraSpacing / 2)
  }
}

public extension TypeStyle {
  // MARK: Heading
  static let H1 = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 28),
    uiFont: .pretendard(type: .semibold, size: 28),
    size: 28,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  static let H2 = TypeStyle(
    font: .Pretendard.bold.swiftUIFont(size: 24),
    uiFont: .pretendard(type: .bold, size: 24),
    size: 24,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )

  static let H3 = TypeStyle(
    font: .Pretendard.bold.swiftUIFont(size: 20),
    uiFont: .pretendard(type: .bold, size: 20),
    size: 20,
    lineHeight: 1.4,
    letterSpacing: -0.02
  )

  static let H4_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 18),
    uiFont: .pretendard(type: .semibold, size: 18),
    size: 18,
    lineHeight: 1.4,
    letterSpacing: -0.02
  )

  static let H4_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 18),
    uiFont: .pretendard(type: .medium, size: 18),
    size: 18,
    lineHeight: 1.4,
    letterSpacing: -0.02
  )

  // MARK: Body
  static let B1_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 16),
    uiFont: .pretendard(type: .semibold, size: 16),
    size: 16,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )

  static let B1_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 16),
    uiFont: .pretendard(type: .medium, size: 16),
    size: 16,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )

  static let B1_M_HL = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 16),
    uiFont: .pretendard(type: .medium, size: 16),
    size: 16,
    lineHeight: 1.7,
    letterSpacing: -0.02
  )

  static let B2_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 14),
    uiFont: .pretendard(type: .semibold, size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )

  static let B2_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 14),
    uiFont: .pretendard(type: .medium, size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )

  static let B3_R_HLM = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 14),
    uiFont: .pretendard(type: .medium, size: 14),
    size: 14,
    lineHeight: 1.7,
    letterSpacing: -0.02
  )

  // MARK: Caption
  static let C1 = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 16),
    uiFont: .pretendard(type: .regular, size: 16),
    size: 16,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )

  static let C2 = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 14),
    uiFont: .pretendard(type: .regular, size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )
}

//public struct TypeStyle {
//  public let font: Font
//  public let size: CGFloat
//  public let lineHeight: CGFloat   // 1.3 = 130%
//  public let letterSpacing: CGFloat   // -0.02 = -2%
//  
//  public init(
//    font: Font, size: CGFloat,
//    lineHeight: CGFloat,
//    letterSpacing: CGFloat = 0
//  ) {
//    self.font = font
//    self.size = size
//    self.lineHeight = lineHeight
//    self.letterSpacing = letterSpacing
//  }
//  
//  public var lineSpacing: CGFloat { (size * lineHeight) - size }
//}
//
//public extension Font {
//  enum Pretendard {
//    case semibold
//    case bold
//    case regular
//    case medium
//    
//    var convertible: DesignSystemFontConvertible {
//      switch self {
//      case .semibold:
//        return DesignSystemFontFamily.Pretendard.semiBold
//      case .bold:
//        return DesignSystemFontFamily.Pretendard.bold
//      case .regular:
//        return DesignSystemFontFamily.Pretendard.regular
//      case .medium:
//        return DesignSystemFontFamily.Pretendard.medium
//      }
//    }
//  }
//  
//  /// Pretendard 커스텀 폰트 생성
//   ///
//   /// - Parameters:
//   ///   - type: Pretendard 가중치
//   ///   - size: 포인트 크기
//   /// - Returns: SwiftUI `Font`
//  static func pretendard(type: Pretendard, size: CGFloat) -> Font {
//    return type.convertible.swiftUIFont(size: size)
//  }
//}
//
//public extension TypeStyle {
//  //MARK: - Heading
//  /// SemiBold, 28
//  static let H1 = TypeStyle(
//    font: .pretendard(
//      type: .semibold,
//      size: 28
//    ),
//    size: 28,
//    lineHeight: 1.3,
//    letterSpacing: -0.04
//  )
//  
//  /// Bold, 24
//  static let H2 = TypeStyle(
//    font: .pretendard(
//      type: .bold,
//      size: 24
//    ),
//    size: 24,
//    lineHeight: 1.3,
//    letterSpacing: -0.04
//  )
//  
//  /// Bold, 20
//  static let H3 = TypeStyle(
//    font: .pretendard(
//      type: .bold,
//      size: 20
//    ),
//    size: 20,
//    lineHeight: 1.4,
//    letterSpacing: -0.02
//  )
//  
//  /// SemiBold, 18
//  static let H4_SB = TypeStyle(
//    font: .pretendard(
//      type: .semibold,
//      size: 18
//    ),
//    size: 18,
//    lineHeight: 1.4,
//    letterSpacing: -0.02
//  )
//  
//  /// Medium, 18
//  static let H4_M = TypeStyle(
//    font: .pretendard(
//      type: .medium,
//      size: 18
//    ),
//    size: 18,
//    lineHeight: 1.4,
//    letterSpacing: -0.02
//  )
//  
//  // MARK: - Body
//  /// SemiBold, 16
//  static let B1_SB = TypeStyle(
//    font: .pretendard(
//      type: .semibold,
//      size: 16
//    ),
//    size: 16,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//  
//  /// Medium, 16
//  static let B1_M = TypeStyle(
//    font: .pretendard(
//      type: .medium,
//      size: 16
//    ),
//    size: 16,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//  
//  /// Medium, 16
//  static let B1_M_HL = TypeStyle(
//    font: .pretendard(
//      type: .medium,
//      size: 16
//    ),
//    size: 16,
//    lineHeight: 1.7,
//    letterSpacing: -0.02
//  )
//  
//  /// SemiBold, 14
//  static let B2_SB = TypeStyle(
//    font: .pretendard(
//      type: .semibold,
//      size: 14
//    ),
//    size: 14,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//  
//  /// Medium, 14
//  static let B2_M = TypeStyle(
//    font: .pretendard(
//      type: .medium,
//      size: 14
//    ),
//    size: 14,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//  
//  /// Medium, 14
//  static let B3_R_HLM = TypeStyle(
//    font: .pretendard(
//      type: .medium,
//      size: 14
//    ),
//    size: 14,
//    lineHeight: 1.7,
//    letterSpacing: -0.02
//  )
//  
//  // MARK: - Caption
//  /// Regular, 16
//  static let C1 = TypeStyle(
//    font: .pretendard(
//      type: .regular,
//      size: 16
//    ),
//    size: 16,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//  
//  /// Regular, 14
//  static let C2 = TypeStyle(
//    font: .pretendard(
//      type: .regular,
//      size: 14
//    ),
//    size: 14,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//}

//public extension View {
//  /// 타입 스타일을 한 줄로 적용합니다.
//  ///
//  /// 예:
//  /// ```swift
//  /// Text("예시")
//  ///   .font(.H1) // 폰트 + 줄간격 + 자간 적용
//  /// ```
//  ///
//  /// - Parameter style: `TypeStyle` 프리셋(H1/B1_M 등)
//  /// - Returns: 스타일이 적용된 뷰
//  func font(_ style: TypeStyle) -> some View {
//    self
//      .font(style.font)
//      .lineSpacing(style.lineSpacing)
//      .kerning(style.letterSpacing / style.size) // Figma px기준 → 비율로 보정
//  }
//}

//struct FontWithLineHeight: ViewModifier {
//    let font: UIFont // 입력받은 폰트
//    let lineHeight: CGFloat // Text 의 전체 높이 (Full Height)
//
//    func body(content: Content) -> some View {
//        content
//            .font(Font(font))
//            .lineSpacing(lineHeight - font.lineHeight)
//            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
//    }
//}
//
//func fontWithLineHeight(fontLevel: FontLevel) -> some View { // FontLevel 은 직접 만든 Enum
//    return ModifiedContent(content: self,
//                           modifier: FontWithLineHeight(font: Font.uiFontGuide(fontLevel),
//                                                        lineHeight: fontLevel.lineHeight))
//}
//
//static func uiFontGuide(_ fontLevel: FontLevel) -> UIFont {
//    return UIFont(name: fontLevel.fontWeight, size: fontLevel.fontSize)!
//}
