//
//  RecentLinkListView.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

import Domain
import DesignSystem

// MARK: - Properties
struct RecentLinkListView: View {
  
}

// MARK: - View
extension RecentLinkListView {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("최근 본 링크")
        .font(.B2_SB)
        .foregroundStyle(.caption2)
      
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack {
          ForEach(1..<6) { _ in
            LinkCard(title: "트럼프 11월 1일부터 중대형 트럭에 25% 관세 부과", newsCompany: "조선 비즈", image: "plus", date: "2025년 10월 7일")
          }
        }
      }
    }
    .background(Color.background)
    .padding(.horizontal, 20)
  }
}

#Preview {
  RecentLinkListView()
}
