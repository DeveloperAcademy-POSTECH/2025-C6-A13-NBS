//
//  LinkDetailSegment.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI
import DesignSystem

/// 링크 상세 하단 세그먼트 (예: 요약 / 추가 메모)
struct LinkDetailSegment: View {
  @Binding var selectedTab: Tab
  
  enum Tab: String, CaseIterable {
    case summary = "요약"
    case memo = "추가 메모"
  }
}

// MARK: - Body
extension LinkDetailSegment {
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 10) {
        ForEach(Tab.allCases, id: \.self) { tab in
          Button {
            withAnimation(.easeInOut(duration: 0.25)) {
              selectedTab = tab
            }
          } label: {
            VStack(alignment: .center, spacing: 4) {
              Text(tab.rawValue)
                .font(.B1_M)
                .foregroundStyle(selectedTab == tab ? .bl6 : .caption3)
                .frame(maxWidth: .infinity)
              
              Rectangle()
                .fill(selectedTab == tab ? Color.bl6 : .clear)
                .frame(height: 4)
                .cornerRadius(16)
                .animation(.easeInOut, value: selectedTab)
            }
            .frame(maxWidth: .infinity)
          }
          .buttonStyle(.plain)
        }
      }
      .padding(.horizontal, 22.5)
      .background(Color.background)
      
      Divider()
        .frame(height: 1)
        .foregroundStyle(.divider1)
    }
  }
}
