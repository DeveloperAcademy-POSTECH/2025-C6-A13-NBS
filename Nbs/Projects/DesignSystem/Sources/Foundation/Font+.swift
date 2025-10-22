//
//  Font+.swift
//  DesignSystem
//
//  Created by 이안 on 10/14/25.
//

import SwiftUI
import UIKit

// MARK: - TypeStyle

/// 커스텀 텍스트 스타일
///
/// `Font`(SwiftUI) + `UIFont`(UIKit)를 함께 관리하면서,
/// 줄간격(lineHeight), 자간(letterSpacing)을 실제 pt 단위로 자동 계산해 적용합니다.
///
/// - Note:
///   - `lineHeight`: Figma 기준 배수 (예: 1.5 = 150%)
///   - `letterSpacing`: 폰트 크기에 대한 비율 (-0.02 = -2%)
///   - `extraSpacing`: 실제 라인 간격(pt)
///
/// 사용 예시:
/// ```swift
/// Text("제목")
///   .font(.H1)
/// ```
public struct TypeStyle {
  public let font: Font             // SwiftUI 폰트 (Pretendard)
  public let uiFont: UIFont         // 실제 UIKit 폰트
  public let size: CGFloat          // 폰트 사이즈
  public let lineHeight: CGFloat    // 기준 배수 (ex. 1.5)
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
  
  /// 실제 pt 기반 보정값 계산
  public var extraSpacing: CGFloat {
    max((size * lineHeight) - uiFont.lineHeight, 0)
  }
  
  /// 실제 pt 단위 자간 변환
  public var letterSpacingPx: CGFloat {
    letterSpacing * size
  }
}

// MARK: - Pretendard 연결
/// Pretendard 폰트를 Tuist DesignSystemFontFamily와 연결하는 Enum
///
/// - Example:
/// ```swift
/// Font.Pretendard.semibold.swiftUIFont(size: 20)
/// UIFont.pretendard(type: .semibold, size: 20)
/// ```
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
    
    /// UIKit 폰트 반환
    func font(size: CGFloat) -> UIFont {
      convertible.font(size: size)
    }
    
    /// SwiftUI 폰트 반환
    func swiftUIFont(size: CGFloat) -> Font {
      convertible.swiftUIFont(size: size)
    }
  }
}

/// UIView 폰트 변환 헬퍼
private extension UIFont {
  static func pretendard(type: Font.Pretendard, size: CGFloat) -> UIFont {
    type.font(size: size)
  }
}

// MARK: - View Extension
/// 커스텀 폰트 스타일(`TypeStyle`)을 한 줄로 적용하는 확장 메서드
///
/// - Example:
/// ```swift
/// Text("본문 텍스트")
///   .font(.B1_M)
/// ```
public extension View {
  func font(_ style: TypeStyle) -> some View {
    self
      .font(style.font)
      .kerning(style.letterSpacingPx)
      .lineSpacing(style.extraSpacing)
      .padding(.vertical, style.extraSpacing / 2)
  }
}

// MARK: - Style Presets
/// 프로젝트 전역에서 사용 가능한 텍스트 스타일 프리셋 모음
public extension TypeStyle {
  // MARK: Heading
  /// SemiBold 28pt
  static let H1 = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 28),
    uiFont: .pretendard(type: .semibold, size: 28),
    size: 28,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  ///Bold 24pt
  static let H2 = TypeStyle(
    font: .Pretendard.bold.swiftUIFont(size: 24),
    uiFont: .pretendard(type: .bold, size: 24),
    size: 24,
    lineHeight: 1.3,
    letterSpacing: -0.04
  )
  
  /// Bold 20pt
  static let H3 = TypeStyle(
    font: .Pretendard.bold.swiftUIFont(size: 20),
    uiFont: .pretendard(type: .bold, size: 20),
    size: 20,
    lineHeight: 1.4,
    letterSpacing: -0.02
  )
  
  /// SemiBold 18pt
  static let H4_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 18),
    uiFont: .pretendard(type: .semibold, size: 18),
    size: 18,
    lineHeight: 1.4,
    letterSpacing: -0.02
  )
  
  /// Medium 18pt
  static let H4_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 18),
    uiFont: .pretendard(type: .medium, size: 18),
    size: 18,
    lineHeight: 1.4,
    letterSpacing: -0.02
  )
  
  // MARK: Body
  /// SemiBold 16pt
  static let B1_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 16),
    uiFont: .pretendard(type: .semibold, size: 16),
    size: 16,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )
  
  /// Medium 16pt
  static let B1_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 16),
    uiFont: .pretendard(type: .medium, size: 16),
    size: 16,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )
  
  /// Medium 16pt
  static let B1_M_HL = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 16),
    uiFont: .pretendard(type: .medium, size: 16),
    size: 16,
    lineHeight: 1.7,
    letterSpacing: -0.02
  )
  
  /// Medium 14pt
  static let B2_SB = TypeStyle(
    font: .Pretendard.semibold.swiftUIFont(size: 14),
    uiFont: .pretendard(type: .semibold, size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )
  
  /// Medium 14pt
  static let B2_M = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 14),
    uiFont: .pretendard(type: .medium, size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )
  
  /// Medium 14pt
  static let B3_R_HLM = TypeStyle(
    font: .Pretendard.medium.swiftUIFont(size: 14),
    uiFont: .pretendard(type: .medium, size: 14),
    size: 14,
    lineHeight: 1.7,
    letterSpacing: -0.02
  )
  
  // MARK: Caption
  /// Regular 16pt
  static let C1 = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 16),
    uiFont: .pretendard(type: .regular, size: 16),
    size: 16,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )
  
  /// Regular 14pt
  static let C2 = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 14),
    uiFont: .pretendard(type: .regular, size: 14),
    size: 14,
    lineHeight: 1.5,
    letterSpacing: -0.02
  )
  
  ///Regular 12pt
  static let C3 = TypeStyle(
    font: .Pretendard.regular.swiftUIFont(size: 12),
    uiFont: .pretendard(type: .regular, size: 12),
    size: 12,
    lineHeight: 1.7,
    letterSpacing: 0.0
  )
}
