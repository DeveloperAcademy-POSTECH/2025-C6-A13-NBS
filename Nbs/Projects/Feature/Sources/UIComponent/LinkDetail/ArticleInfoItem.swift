//
//  ArticleInfoItem.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI

/// 기사 정보 아이템 (날짜, 언론사명, 카테고리)
struct ArticleInfoItem: View {
  let icon: String
  let text: String
  
  var body: some View {
    HStack(spacing: 8) {
      Image(icon: icon)
        .renderingMode(.template)
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24)
        .foregroundStyle(.bl4)
      
      Text(text)
        .font(.B1_M)
        .foregroundStyle(.caption1)
    }
  }
}
