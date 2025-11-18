//
//  OnboardingTooltipBox.swift
//  DesignSystem
//
//  Created by 홍 on 11/8/25.
//

import SwiftUI

public struct OnboardingToolTipBox {
  let text: String
  
  public init(text: String) {
    self.text = text
  }
}

extension OnboardingToolTipBox: View {
  public var body: some View {
    VStack(spacing: 0) {
      
      Triangle()
        .rotation(.degrees(180))
        .fill(.bl6)
        .frame(width: 16, height: 8)
      
      Text(text)
        .font(.H4_M)
        .foregroundStyle(.textw)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(.bl6)
        )
    }
  }
}

public struct OnboardingToolTipBoxBottom {
  let text: String
  
  public init(text: String) {
    self.text = text
  }
}

extension OnboardingToolTipBoxBottom: View {
  public var body: some View {
    VStack(spacing: 0) {
      Text(text)
        .font(.H4_M)
        .foregroundStyle(.textw)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(.bl6)
        )
      Triangle()
        .fill(.bl6)
        .frame(width: 16, height: 10)
    }
  }
}

public struct OnboardingToolTipBoxBottomTrailing {
  let text: String
  
  public init(text: String) {
    self.text = text
  }
}

extension OnboardingToolTipBoxBottomTrailing: View {
  public var body: some View {
    VStack(spacing: 0) {
      Text(text)
        .font(.H4_M)
        .foregroundStyle(.textw)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(.bl6)
        )
        .overlay(alignment: .bottomTrailing) {
          Triangle()
            .fill(.bl6)
            .frame(width: 18, height: 12)
            .padding(.trailing, 28)
            .padding(.bottom, -15)
        }
    }
  }
}

public struct OnboardingToolTipBoxTopLeading {
  let text: String
  
  public init(text: String) {
    self.text = text
  }
}

extension OnboardingToolTipBoxTopLeading: View {
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Triangle()
        .rotation(.degrees(180))
        .fill(.bl6)
        .frame(width: 16, height: 10)
        .padding(.leading, 14)

      Text(text)
        .font(.H4_M)
        .foregroundStyle(.textw)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(.bl6)
        )
    }
  }
}

#Preview {
  OnboardingToolTipBoxTopLeading(text: "g하이g하이g하이g하이g하이")
}

// MARK: - Triangle Shape
fileprivate struct Triangle: Shape {
  var cornerRadius: CGFloat = 2
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let top = CGPoint(x: rect.midX, y: rect.maxY)
    let bottomLeft = CGPoint(x: rect.minX, y: rect.minY)
    let bottomRight = CGPoint(x: rect.maxX, y: rect.minY)
    
    path.move(to: bottomLeft)
    
    path.addArc(
      tangent1End: top,
      tangent2End: bottomRight,
      radius: cornerRadius
    )
    
    path.addLine(to: bottomRight)
    path.addLine(to: bottomLeft)
    
    path.closeSubpath()
    return path
  }
}

//TODO: 왜 안될까..?.?
//public struct OnboardingToolTipBoxNew {
//  let text: String
//  let direction: ArrowDirection
//  
//  public init(text: String, direction: ArrowDirection = .top) {
//    self.text = text
//    self.direction = direction
//  }
//  
//  public enum ArrowDirection {
//    case top
//    case topLeading
//    case bottom
//    case bottomTrailing
//  }
//}
//
//extension OnboardingToolTipBoxNew: View {
//  public var body: some View {
//    VStack(alignment: direction.alignment, spacing: 0) {
//      Group {
//        if direction.isTop {
//          arrowView
//        }
//      }
//      
//      Text(text)
//        .font(.B1_M_HL)
//        .foregroundStyle(.textw)
//        .padding(.horizontal, 14)
//        .padding(.vertical, 6)
//        .background(
//          RoundedRectangle(cornerRadius: 4)
//            .fill(.bl6)
//        )
//        .overlay(alignment: direction.overlayAlignment) {
//          if direction == .bottomTrailing {
//            Triangle()
//              .fill(.bl6)
//              .frame(width: 18, height: 12)
//              .padding(.trailing, 14)
//              .padding(.bottom, -15)
//          }
//        }
//      
//      Group {
//        if direction.isBottom && direction != .bottomTrailing {
//          arrowView
//        }
//      }
//    }
//  }
//  
//  private var arrowView: some View {
//    Triangle()
//      .rotation(.degrees(direction.rotation))
//      .fill(.bl6)
//      .frame(width: direction.arrowWidth, height: direction.arrowHeight)
//      .padding(.leading, direction.leadingPadding)
//  }
//}
//
//extension OnboardingToolTipBoxNew.ArrowDirection {
//  var alignment: HorizontalAlignment {
//    switch self {
//    case .topLeading: return .leading
//    default: return .center
//    }
//  }
//  
//  var overlayAlignment: Alignment {
//    switch self {
//    case .bottomTrailing: return .bottomTrailing
//    default: return .center
//    }
//  }
//  
//  var isTop: Bool {
//    self == .top || self == .topLeading
//  }
//  
//  var isBottom: Bool {
//    self == .bottom || self == .bottomTrailing
//  }
//  
//  var rotation: Double {
//    isTop ? 180 : 0
//  }
//  
//  var arrowWidth: CGFloat {
//    switch self {
//    case .bottomTrailing: return 18
//    default: return 16
//    }
//  }
//  
//  var arrowHeight: CGFloat {
//    return 8
//  }
//  
//  var leadingPadding: CGFloat {
//    self == .topLeading ? 14 : 0
//  }
//}
