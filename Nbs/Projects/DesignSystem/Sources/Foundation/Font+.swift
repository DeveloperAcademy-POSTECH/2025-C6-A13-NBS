//
//  Font+.swift
//  DesignSystem
//
//  Created by 이안 on 10/14/25.
//

import SwiftUI

// MARK: - TypeStyle

/// 텍스트 스타일 토큰
///
/// `Font`와 함께 줄 간격(line height)과 자간(letter spacing)을 한 번에 적용하기 위한 구조체
///
/// - Note: `lineHeightMultiplier`는 폰트 크기에 대한 배수(예: 1.3 = 130%)
///         `letterSpacingPercent`는 폰트 크기에 대한 퍼센트(예: -0.02 = -2%)
public struct TypeStyle {
  public let font: Font
  public let size: CGFloat
  public let lineHeightMultiplier: CGFloat   // 1.3 = 130%
  public let letterSpacingPercent: CGFloat   // -0.02 = -2%
  
  public init(
    font: Font, size: CGFloat,
    lineHeightMultiplier: CGFloat,
    letterSpacingPercent: CGFloat = 0
  ) {
    self.font = font
    self.size = size
    self.lineHeightMultiplier = lineHeightMultiplier
    self.letterSpacingPercent = letterSpacingPercent
  }
  
  public var lineSpacing: CGFloat { size * lineHeightMultiplier - size }
  public var tracking: CGFloat { size * letterSpacingPercent }
}

public extension Font {
  enum Pretendard {
    case semibold
    case bold
    case regular
    case medium
    
    var value: String {
      switch self {
      case .semibold:
        return "PretendardVariable-SemiBold"
      case .bold:
        return "PretendardVariable-Bold"
      case .regular:
        return "PretendardVariable-Regular"
      case .medium:
        return "PretendardVariable-Medium"
      }
    }
  }
  
  /// Pretendard 커스텀 폰트 생성
   ///
   /// - Parameters:
   ///   - type: Pretendard 가중치
   ///   - size: 포인트 크기
   /// - Returns: SwiftUI `Font`
  static func pretendard(type: Pretendard, size: CGFloat) -> Font {
    return .custom(type.value, size: size)
  }
}

public extension TypeStyle {
  //MARK: - Heading
  /// SemiBold, 28
  static let H1 = TypeStyle(
    font: .pretendard(
      type: .semibold,
      size: 28
    ),
    size: 28,
    lineHeightMultiplier: 1.3,
    letterSpacingPercent: -0.04
  )
  
  /// Bold, 24
  static let H2 = TypeStyle(
    font: .pretendard(
      type: .bold,
      size: 24
    ),
    size: 24,
    lineHeightMultiplier: 1.3,
    letterSpacingPercent: -0.04
  )
  
  /// Bold, 20
  static let H3 = TypeStyle(
    font: .pretendard(
      type: .bold,
      size: 20
    ),
    size: 20,
    lineHeightMultiplier: 1.4,
    letterSpacingPercent: -0.02
  )
  
  /// SemiBold, 18
  static let H4_SB = TypeStyle(
    font: .pretendard(
      type: .semibold,
      size: 18
    ),
    size: 18,
    lineHeightMultiplier: 1.4,
    letterSpacingPercent: -0.02
  )
  
  /// Medium, 18
  static let H4_M = TypeStyle(
    font: .pretendard(
      type: .medium,
      size: 18
    ),
    size: 18,
    lineHeightMultiplier: 1.4,
    letterSpacingPercent: -0.02
  )
  
  // MARK: - Body
  /// SemiBold, 16
  static let B1_SB = TypeStyle(
    font: .pretendard(
      type: .semibold,
      size: 16
    ),
    size: 16,
    lineHeightMultiplier: 1.5,
    letterSpacingPercent: -0.02
  )
  
  /// Medium, 16
  static let B1_M = TypeStyle(
    font: .pretendard(
      type: .medium,
      size: 16
    ),
    size: 16,
    lineHeightMultiplier: 1.5,
    letterSpacingPercent: -0.02
  )
  
  /// Medium, 16
  static let B1_M_HL = TypeStyle(
    font: .pretendard(
      type: .medium,
      size: 16
    ),
    size: 16,
    lineHeightMultiplier: 1.7,
    letterSpacingPercent: -0.02
  )
  
  /// SemiBold, 14
  static let B2_SB = TypeStyle(
    font: .pretendard(
      type: .semibold,
      size: 14
    ),
    size: 14,
    lineHeightMultiplier: 1.5,
    letterSpacingPercent: -0.02
  )
  
  /// Medium, 14
  static let B2_M = TypeStyle(
    font: .pretendard(
      type: .medium,
      size: 14
    ),
    size: 14,
    lineHeightMultiplier: 1.5,
    letterSpacingPercent: -0.02
  )
  
  /// Medium, 14
  static let B3_R_HLM = TypeStyle(
    font: .pretendard(
      type: .medium,
      size: 14
    ),
    size: 14,
    lineHeightMultiplier: 1.7,
    letterSpacingPercent: -0.02
  )
  
  // MARK: - Caption
  /// Regular, 16
  static let C1 = TypeStyle(
    font: .pretendard(
      type: .regular,
      size: 16
    ),
    size: 16,
    lineHeightMultiplier: 1.5,
    letterSpacingPercent: -0.02
  )
  
  /// Regular, 14
  static let C2 = TypeStyle(
    font: .pretendard(
      type: .regular,
      size: 14
    ),
    size: 14,
    lineHeightMultiplier: 1.5,
    letterSpacingPercent: -0.02
  )
}

public extension View {
  /// 타입 스타일을 한 줄로 적용합니다.
  ///
  /// 예:
  /// ```swift
  /// Text("예시")
  ///   .font(.H1) // 폰트 + 줄간격 + 자간 적용
  /// ```
  ///
  /// - Parameter style: `TypeStyle` 프리셋(H1/B1_M 등)
  /// - Returns: 스타일이 적용된 뷰
  func font(_ style: TypeStyle) -> some View {
    self
      .font(style.font)
      .lineSpacing(style.lineSpacing)
      .tracking(style.tracking)
  }
}
