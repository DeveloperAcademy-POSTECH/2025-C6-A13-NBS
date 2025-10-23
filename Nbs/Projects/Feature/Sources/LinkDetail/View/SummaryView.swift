//
//  SummaryView.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI
import Domain

struct SummaryView: View {
  let link: LinkItem
}

extension SummaryView {
  var body: some View {
    ScrollView {
      VStack(spacing: 32) {
        ForEach(groupedHighlights.keys.sorted(by: sortOrder), id: \.self) { key in
          if let items = groupedHighlights[key],
             let type = SummaryTypeItem.SummaryType(rawValue: key) {
            VStack(alignment: .leading, spacing: 24) {
              SummaryTypeItem(type: type)
              
              // 같은 type의 highlight를 모아서 출력
              ForEach(items) { item in
                highlightContents(for: item, type: type)
              }
            }
          }
        }
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 24)
    }
    .background(Color.background)
  }
  
  /// 하이라이트 섹션
  private func highlightContents(for item: HighlightItem, type: SummaryTypeItem.SummaryType) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      // 문장 (하이라이팅)
      Text(item.sentence)
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(type.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
      
      // 코멘트 리스트
      if !item.comments.isEmpty {
        VStack(alignment: .leading, spacing: 8) {
          ForEach(item.comments, id: \.id) { comment in
            Text("\(comment.text)")
              .font(.B3_R_HLM)
              .foregroundStyle(.caption1)
          }
        }
        .padding(.horizontal, 16)
      }
      
      Rectangle()
        .fill(.divider1)
        .frame(height: 1)
    }
  }
  
  ///  type별 그룹핑된 highlights
  private var groupedHighlights: [String: [HighlightItem]] {
    Dictionary(grouping: link.highlights) { item in
      item.type.capitalized
    }
  }
  
  /// 출력 순서 (What → Why → Detail)
  private func sortOrder(lhs: String, rhs: String) -> Bool {
    let order: [String: Int] = ["What": 0, "Why": 1, "Detail": 2]
    return (order[lhs] ?? 99) < (order[rhs] ?? 99)
  }
}
