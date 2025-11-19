//
//  SummaryTypeItem.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI
import DesignSystem

/// 하이라이트 아이템 (Pink / Yellow / Blue)
struct SummaryTypeItem: View {
  enum SummaryType: String {
    case pink = "Pink"
    case yellow = "Yellow"
    case blue = "Blue"
    
    var textColor: Color {
      switch self {
      case .pink: return .textWhat
      case .yellow: return .textWhy
      case .blue: return .textDetail
      }
    }
    
    var backgroundColor: Color {
      switch self {
      case .pink: return .bgWhat
      case .yellow: return .bgWhy
      case .blue: return .bgDetail
      }
    }
  }
  
  let type: SummaryType
}

extension SummaryTypeItem {
  var body: some View {
    HStack(spacing: 8) {
      RoundedRectangle(cornerRadius: 4)
        .fill(type.backgroundColor)
        .frame(width: 24, height: 24)
      
      Text(type.rawValue)
        .font(.B1_M)
        .foregroundStyle(type.textColor)
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    SummaryTypeItem(type: .pink)
    SummaryTypeItem(type: .yellow)
    SummaryTypeItem(type: .blue)
  }
}
