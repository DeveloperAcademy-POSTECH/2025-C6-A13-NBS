//
//  Color+.swift
//  DesignSystem
//
//  Created by 이안 on 10/14/25.
//

import SwiftUI

// MARK: - Design System Color Tokens

/// `DesignSystemAsset`의 색상 토큰을 SwiftUI Color 정적 프로퍼티로 노출
///
/// 예:
/// ```swift
/// Text("background").foregroundStyle(.background)
/// Rectangle().fill(.background)
/// Divider().background(.divider1)
/// ```
///
/// - Note: Color Asset은 DesignSystem 모듈의 .module 번들에 있어야 함
///         (SwiftGen/수동 래퍼 등으로 생성된 DesignSystemAsset 기반)
public extension ShapeStyle where Self == Color {
  // MARK: Background / Dim
  /// 기본 배경색
  static var background: Color { DesignSystemAsset.background.swiftUIColor }
  static var alert: Color { DesignSystemAsset.alert.swiftUIColor }
  static var alertColor: Color { DesignSystemAsset.alertColor.swiftUIColor }
  static var bgBtn: Color { DesignSystemAsset.bgBtn.swiftUIColor }
  static var bgButtonGrad1: Color { DesignSystemAsset.bgButtonGra1.swiftUIColor }
  static var bgButtonGrad2: Color { DesignSystemAsset.bgButtonGra2.swiftUIColor }
  static var bgButtonGrad3: Color { DesignSystemAsset.bgButtonGra3.swiftUIColor }
  static var bgButtonGrad4: Color { DesignSystemAsset.bgButtonGra4.swiftUIColor }
  static var bgDetail: Color { DesignSystemAsset.bgDetail.swiftUIColor }
  static var bgDim: Color { DesignSystemAsset.bgDim.swiftUIColor }
  static var bgDimCard: Color { DesignSystemAsset.bgDimCard.swiftUIColor }
  static var bgDimSelect: Color { DesignSystemAsset.bgDimSelect.swiftUIColor }
  static var bgMemo: Color { DesignSystemAsset.bgMemo.swiftUIColor }
  static var bgShadow1: Color { DesignSystemAsset.bgShadow1.swiftUIColor }
  static var bgShadow2: Color { DesignSystemAsset.bgShadow2.swiftUIColor }
  static var bgWhat: Color { DesignSystemAsset.bgWhat.swiftUIColor }
  static var bgWhy: Color { DesignSystemAsset.bgWhy.swiftUIColor }
  
  /// 딤(모달/시트 배경에 사용)
  static var dim: Color { DesignSystemAsset.dim.swiftUIColor }

  // MARK: Text
  /// 기본 텍스트 컬러
  static var text1: Color { DesignSystemAsset.text1.swiftUIColor }
  /// 흰색 텍스트(반전 영역)
  static var textw: Color { DesignSystemAsset.textw.swiftUIColor }
  /// 캡션/보조 텍스트1
  static var caption1: Color { DesignSystemAsset.caption1.swiftUIColor }
  /// 캡션/보조 텍스트2
  static var caption2: Color { DesignSystemAsset.caption2.swiftUIColor }
  /// 캡션/보조 텍스트3
  static var caption3: Color { DesignSystemAsset.caption3.swiftUIColor }
  
  static var textWhat: Color { DesignSystemAsset.textWhat.swiftUIColor }
  static var textWhy: Color { DesignSystemAsset.textWhy.swiftUIColor }
  static var textDetail: Color { DesignSystemAsset.textDetail.swiftUIColor }

  // MARK: Divider
  static var divider1: Color { DesignSystemAsset.divider1.swiftUIColor }
  static var divider2: Color { DesignSystemAsset.divider2.swiftUIColor }
  
  // MARK: IconColor
  static var icon: Color { DesignSystemAsset.icon.swiftUIColor }
  static var iconDisabled: Color { DesignSystemAsset.iconDisabled.swiftUIColor }
  static var iconGray: Color { DesignSystemAsset.iconGray.swiftUIColor }
  static var iconW: Color { DesignSystemAsset.iconW.swiftUIColor}

  // MARK: State
  static var success: Color { DesignSystemAsset.success.swiftUIColor }
  static var danger: Color { DesignSystemAsset.danger.swiftUIColor }
  static var successBg: Color { DesignSystemAsset.successBg.swiftUIColor }
  
  // MARK: Neutral scale (n0 ~ n900)
  static var n0:   Color { DesignSystemAsset.n0.swiftUIColor }
  static var n10:  Color { DesignSystemAsset.n10.swiftUIColor }
  static var n20:  Color { DesignSystemAsset.n20.swiftUIColor }
  static var n30:  Color { DesignSystemAsset.n30.swiftUIColor }
  static var n40:  Color { DesignSystemAsset.n40.swiftUIColor }
  static var n50:  Color { DesignSystemAsset.n50.swiftUIColor }
  static var n60:  Color { DesignSystemAsset.n60.swiftUIColor }
  static var n70:  Color { DesignSystemAsset.n70.swiftUIColor }
  static var n80:  Color { DesignSystemAsset.n80.swiftUIColor }
  static var n90:  Color { DesignSystemAsset.n90.swiftUIColor }
  static var n100: Color { DesignSystemAsset.n100.swiftUIColor }
  static var n200: Color { DesignSystemAsset.n200.swiftUIColor }
  static var n300: Color { DesignSystemAsset.n300.swiftUIColor }
  static var n400: Color { DesignSystemAsset.n400.swiftUIColor }
  static var n500: Color { DesignSystemAsset.n500.swiftUIColor }
  static var n600: Color { DesignSystemAsset.n600.swiftUIColor }
  static var n700: Color { DesignSystemAsset.n700.swiftUIColor }
  static var n800: Color { DesignSystemAsset.n800.swiftUIColor }
  static var n900: Color { DesignSystemAsset.n900.swiftUIColor }

  // MARK: Blues (bl1 ~ bl10)
  static var bl1:  Color { DesignSystemAsset.bl1.swiftUIColor }
  static var bl2:  Color { DesignSystemAsset.bl2.swiftUIColor }
  static var bl3:  Color { DesignSystemAsset.bl3.swiftUIColor }
  static var bl4:  Color { DesignSystemAsset.bl4.swiftUIColor }
  static var bl5:  Color { DesignSystemAsset.bl5.swiftUIColor }
  static var bl6:  Color { DesignSystemAsset.bl6.swiftUIColor }
  static var bl7:  Color { DesignSystemAsset.bl7.swiftUIColor }
  static var bl8:  Color { DesignSystemAsset.bl8.swiftUIColor }
  static var bl9:  Color { DesignSystemAsset.bl9.swiftUIColor }
  static var bl10: Color { DesignSystemAsset.bl10.swiftUIColor }
  
  static var c1:  Color { DesignSystemAsset.c1.swiftUIColor }
  static var c2:  Color { DesignSystemAsset.c2.swiftUIColor }
  static var c3:  Color { DesignSystemAsset.c3.swiftUIColor }
  static var c4:  Color { DesignSystemAsset.c4.swiftUIColor }
  static var c5:  Color { DesignSystemAsset.c5.swiftUIColor }
  static var c6:  Color { DesignSystemAsset.c6.swiftUIColor }
  static var c7:  Color { DesignSystemAsset.c7.swiftUIColor }
  static var c8:  Color { DesignSystemAsset.c8.swiftUIColor }
  static var c9:  Color { DesignSystemAsset.c9.swiftUIColor }
  static var c10: Color { DesignSystemAsset.c10.swiftUIColor }
  static var c11:  Color { DesignSystemAsset.c11.swiftUIColor }
  static var c12:  Color { DesignSystemAsset.c12.swiftUIColor }
  static var c13:  Color { DesignSystemAsset.c13.swiftUIColor }
  static var c14:  Color { DesignSystemAsset.c14.swiftUIColor }
  static var c15: Color { DesignSystemAsset.c15.swiftUIColor }

}
