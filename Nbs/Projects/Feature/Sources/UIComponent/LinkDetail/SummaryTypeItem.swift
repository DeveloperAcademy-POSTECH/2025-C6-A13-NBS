//
//  SummaryTypeItem.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI
import DesignSystem

/// 요약 아이템 (What / Why / Detail)
struct SummaryTypeItem: View {
  enum SummaryType: String {
    case what = "What"
    case why = "Why"
    case detail = "Detail"
    
    var textColor: Color {
      switch self {
      case .what: return .textWhat
      case .why: return .textWhy
      case .detail: return .textDetail
      }
    }
    
    var backgroundColor: Color {
      switch self {
      case .what: return .bgWhat
      case .why: return .bgWhy
      case .detail: return .bgDetail
      }
    }
    
    var shortLabel: String {
      switch self {
      case .what: return "W"
      case .why: return "W"
      case .detail: return "D"
      }
    }
  }
  
  let type: SummaryType
}

extension SummaryTypeItem {
  var body: some View {
    HStack(spacing: 8) {
      Text(type.shortLabel)
        .font(.B2_M)
        .foregroundStyle(type.textColor)
        .frame(width: 24, height: 24)
        .background(type.backgroundColor)
        .cornerRadius(4)
      
      Text(type.rawValue)
        .font(.B1_M)
        .foregroundStyle(type.textColor)
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    SummaryTypeItem(type: .what)
    SummaryTypeItem(type: .why)
    SummaryTypeItem(type: .detail)
  }
}
