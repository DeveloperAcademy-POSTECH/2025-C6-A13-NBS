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
//public struct TypeStyle {
//  public let font: Font          // SwiftUI 폰트 (Pretendard)
//  public let uiFont: UIFont      // 실제 UIKit 폰트
//  public let size: CGFloat       // 폰트 사이즈
//  public let lineHeight: CGFloat // Figma 기준 배수 (ex. 1.5)
//  public let letterSpacing: CGFloat // 퍼센트 (-0.02 = -2%)
//
//  public init(
//    font: Font,
//    uiFont: UIFont,
//    size: CGFloat,
//    lineHeight: CGFloat,
//    letterSpacing: CGFloat
//  ) {
//    self.font = font
//    self.uiFont = uiFont
//    self.size = size
//    self.lineHeight = lineHeight
//    self.letterSpacing = letterSpacing
//  }
//
//  /// Figma lineHeight(배수) → 실제 pt 기반 추가 여백 계산
//  public var extraSpacing: CGFloat {
//    max((size * lineHeight) - uiFont.lineHeight, 0)
//  }
//
//  /// Figma 퍼센트(letterSpacing) → pt 보정
//  public var letterSpacingPx: CGFloat {
//    letterSpacing * size
//  }
//}
//
//// MARK: - Pretendard 연결
//public extension Font {
//  enum Pretendard {
//    case semibold, bold, regular, medium
//
//    var convertible: DesignSystemFontConvertible {
//      switch self {
//      case .semibold: DesignSystemFontFamily.Pretendard.semiBold
//      case .bold: DesignSystemFontFamily.Pretendard.bold
//      case .regular: DesignSystemFontFamily.Pretendard.regular
//      case .medium: DesignSystemFontFamily.Pretendard.medium
//      }
//    }
//
//    func font(size: CGFloat) -> UIFont {
//      convertible.font(size: size)
//    }
//
//    func swiftUIFont(size: CGFloat) -> Font {
//      convertible.swiftUIFont(size: size)
//    }
//  }
//}
//
//// MARK: - UIView 폰트 변환 헬퍼
//private extension UIFont {
//  static func pretendard(type: Font.Pretendard, size: CGFloat) -> UIFont {
//    type.font(size: size)
//  }
//}
//
//// MARK: - View Modifier
//public extension View {
//  func font(_ style: TypeStyle) -> some View {
//    self
//      .font(style.font)
//      .kerning(style.letterSpacingPx)
//      .lineSpacing(style.extraSpacing)
//      .padding(.vertical, style.extraSpacing / 2)
//  }
//}
//
//public extension TypeStyle {
//  // MARK: Heading
//  static let H1 = TypeStyle(
//    font: .Pretendard.semibold.swiftUIFont(size: 28),
//    uiFont: .pretendard(type: .semibold, size: 28),
//    size: 28,
//    lineHeight: 1.3,
//    letterSpacing: -0.04
//  )
//
//  static let H2 = TypeStyle(
//    font: .Pretendard.bold.swiftUIFont(size: 24),
//    uiFont: .pretendard(type: .bold, size: 24),
//    size: 24,
//    lineHeight: 1.3,
//    letterSpacing: -0.04
//  )
//
//  static let H3 = TypeStyle(
//    font: .Pretendard.bold.swiftUIFont(size: 20),
//    uiFont: .pretendard(type: .bold, size: 20),
//    size: 20,
//    lineHeight: 1.4,
//    letterSpacing: -0.02
//  )
//
//  static let H4_SB = TypeStyle(
//    font: .Pretendard.semibold.swiftUIFont(size: 18),
//    uiFont: .pretendard(type: .semibold, size: 18),
//    size: 18,
//    lineHeight: 1.4,
//    letterSpacing: -0.02
//  )
//
//  static let H4_M = TypeStyle(
//    font: .Pretendard.medium.swiftUIFont(size: 18),
//    uiFont: .pretendard(type: .medium, size: 18),
//    size: 18,
//    lineHeight: 1.4,
//    letterSpacing: -0.02
//  )
//
//  // MARK: Body
//  static let B1_SB = TypeStyle(
//    font: .Pretendard.semibold.swiftUIFont(size: 16),
//    uiFont: .pretendard(type: .semibold, size: 16),
//    size: 16,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//
//  static let B1_M = TypeStyle(
//    font: .Pretendard.medium.swiftUIFont(size: 16),
//    uiFont: .pretendard(type: .medium, size: 16),
//    size: 16,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//
//  static let B1_M_HL = TypeStyle(
//    font: .Pretendard.medium.swiftUIFont(size: 16),
//    uiFont: .pretendard(type: .medium, size: 16),
//    size: 16,
//    lineHeight: 1.7,
//    letterSpacing: -0.02
//  )
//
//  static let B2_SB = TypeStyle(
//    font: .Pretendard.semibold.swiftUIFont(size: 14),
//    uiFont: .pretendard(type: .semibold, size: 14),
//    size: 14,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//
//  static let B2_M = TypeStyle(
//    font: .Pretendard.medium.swiftUIFont(size: 14),
//    uiFont: .pretendard(type: .medium, size: 14),
//    size: 14,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//
//  static let B3_R_HLM = TypeStyle(
//    font: .Pretendard.medium.swiftUIFont(size: 14),
//    uiFont: .pretendard(type: .medium, size: 14),
//    size: 14,
//    lineHeight: 1.7,
//    letterSpacing: -0.02
//  )
//
//  // MARK: Caption
//  static let C1 = TypeStyle(
//    font: .Pretendard.regular.swiftUIFont(size: 16),
//    uiFont: .pretendard(type: .regular, size: 16),
//    size: 16,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//
//  static let C2 = TypeStyle(
//    font: .Pretendard.regular.swiftUIFont(size: 14),
//    uiFont: .pretendard(type: .regular, size: 14),
//    size: 14,
//    lineHeight: 1.5,
//    letterSpacing: -0.02
//  )
//}


// MARK: - FontStyle 모델

/// Figma 스타일을 반영한 커스텀 폰트 스타일
/// (폰트, 자간, 행간, 크기를 한 번에 관리)
public struct FontStyle {
  public let font: Font
  public let kerning: CGFloat
  public let lineHeight: CGFloat
  public let fontSize: CGFloat
  
  public init(font: Font, kerning: CGFloat, lineHeight: CGFloat, fontSize: CGFloat) {
    self.font = font
    self.kerning = kerning
    self.lineHeight = lineHeight
    self.fontSize = fontSize
  }
}

// MARK: - Pretendard 폰트 타입 정의
public extension Font {
  enum Pretendard {
    case semibold
    case bold
    case regular
    case medium
    
    /// Tuist가 생성한 DesignSystemFontFamily로부터 연결
    var convertible: DesignSystemFontConvertible {
      switch self {
      case .semibold: DesignSystemFontFamily.Pretendard.semiBold
      case .bold: DesignSystemFontFamily.Pretendard.bold
      case .regular: DesignSystemFontFamily.Pretendard.regular
      case .medium: DesignSystemFontFamily.Pretendard.medium
      }
    }
    
    /// SwiftUI Font 반환
    func swiftUIFont(size: CGFloat) -> Font {
      convertible.swiftUIFont(size: size)
    }
  }
}

// MARK: - FontStyle 프리셋

public extension FontStyle {
  // MARK: Heading
  static let H1 = FontStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 28),
    kerning: -0.01 * 28,
    lineHeight: 1.3,
    fontSize: 28
  )
  
  static let H2 = FontStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 24),
    kerning: -0.01 * 24,
    lineHeight: 1.3,
    fontSize: 24
  )
  
  static let H3 = FontStyle(
    font: Font.Pretendard.bold.swiftUIFont(size: 20),
    kerning: -0.01 * 20,
    lineHeight: 1.4,
    fontSize: 20
  )
  
  static let H4_SB = FontStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 18),
    kerning: -0.01 * 18,
    lineHeight: 1.4,
    fontSize: 18
  )
  
  static let H4_M = FontStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 18),
    kerning: -0.01 * 18,
    lineHeight: 1.4,
    fontSize: 18
  )
  
  // MARK: Body
  static let B1_SB = FontStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 16),
    kerning: -0.01 * 16,
    lineHeight: 1.5,
    fontSize: 16
  )
  
  static let B1_M = FontStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 16),
    kerning: -0.01 * 16,
    lineHeight: 1.5,
    fontSize: 16
  )
  
  static let B1_M_HL = FontStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 16),
    kerning: -0.01 * 16,
    lineHeight: 1.7,
    fontSize: 16
  )
  
  static let B2_SB = FontStyle(
    font: Font.Pretendard.semibold.swiftUIFont(size: 14),
    kerning: -0.01 * 14,
    lineHeight: 1.5,
    fontSize: 14
  )
  
  static let B2_M = FontStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 14),
    kerning: -0.01 * 14,
    lineHeight: 1.5,
    fontSize: 14
  )
  
  static let B3_R_HLM = FontStyle(
    font: Font.Pretendard.medium.swiftUIFont(size: 14),
    kerning: -0.01 * 14,
    lineHeight: 1.7,
    fontSize: 14
  )
  
  // MARK: Caption
  static let C1 = FontStyle(
    font: Font.Pretendard.regular.swiftUIFont(size: 16),
    kerning: -0.01 * 16,
    lineHeight: 1.5,
    fontSize: 16
  )
  
  static let C2 = FontStyle(
    font: Font.Pretendard.regular.swiftUIFont(size: 14),
    kerning: -0.01 * 14,
    lineHeight: 1.5,
    fontSize: 14
  )
  
  
}

// MARK: - ViewModifier

private struct FontModifier: ViewModifier {
  let style: FontStyle
  
  func body(content: Content) -> some View {
    content
      .font(style.font)
      .kerning(style.kerning)
    // Figma lineHeight 대응 (시각적 보정)
      .lineSpacing((style.fontSize * style.lineHeight) - style.fontSize)
      .padding(.vertical, ((style.fontSize * style.lineHeight) - style.fontSize) / 2)
  }
}

// MARK: - View 확장

public extension View {
  /// Figma 기반 커스텀 폰트 스타일을 적용합니다.
  ///
  /// ```swift
  /// Text("타이틀")
  ///   .font(.h1)
  /// ```
  func font(_ style: FontStyle) -> some View {
    self.modifier(FontModifier(style: style))
  }
}
