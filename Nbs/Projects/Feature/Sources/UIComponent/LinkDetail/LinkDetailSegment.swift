//
//  LinkDetailSegment.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI
import DesignSystem

/// 링크 상세 하단 세그먼트 (요약 / 추가 메모)
struct LinkDetailSegment: View {
  @Namespace private var underlineNamespace
  @Binding var selectedTab: Tab
  
  enum Tab: String, CaseIterable, Identifiable {
    case summary = "하이라이트"
    case memo = "추가 메모"
    var id: String { rawValue }
  }
  
  // 각 탭의 텍스트 너비 저장
  @State private var tabWidths: [Tab: CGFloat] = [:]
  
  // 밑줄 높이
  private let underlineHeight: CGFloat = 4
}

extension LinkDetailSegment {
  var body: some View {
    VStack(spacing: .zero) {
      contents
        .padding(.bottom, -underlineHeight)
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(.divider1)
    }
  }
  
  private var contents: some View {
    HStack(spacing: 0) {
      ForEach(Tab.allCases) { tab in
        VStack(spacing: 8) {
          Button {
            withAnimation(.easeInOut(duration: 0.2)) {
              selectedTab = tab
            }
          } label: {
            Text(tab.rawValue)
              .font(.B1_M)
              .foregroundStyle(selectedTab == tab ? .bl6 : .caption3)
              .frame(maxWidth: .infinity)
              .background(GeometryReader { geo in
                Color.clear
                  .preference(
                    key: TabWidthKey.self,
                    value: [tab: geo.size.width]
                  )
              })
          }
          .buttonStyle(.plain)
          ZStack {
            if selectedTab == tab {
              RoundedRectangle(cornerRadius: 16)
                .fill(.bl6)
                .frame(width: tabWidths[tab] ?? 0, height: underlineHeight)
                .matchedGeometryEffect(id: "underline", in: underlineNamespace)
            } else {
              Color.clear.frame(height: underlineHeight)
            }
          }
        }
      }
    }
    .onPreferenceChange(TabWidthKey.self) { value in
      tabWidths.merge(value) { _, new in new }
    }
    .padding(.horizontal, 22.5)
    .frame(height: 45)
    .background(Color.background)
  }
}

/// 세그먼트 항목 너비를 추적하기 위한 PreferenceKey
private struct TabWidthKey: PreferenceKey {
  static var defaultValue: [LinkDetailSegment.Tab: CGFloat] = [:]
  static func reduce(value: inout [LinkDetailSegment.Tab: CGFloat], nextValue: () -> [LinkDetailSegment.Tab: CGFloat]) {
    value.merge(nextValue()) { _, new in new }
  }
}
