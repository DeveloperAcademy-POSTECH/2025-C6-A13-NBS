//
//  EmptySearchView.swift
//  Feature
//
//  Created by 여성일 on 10/19/25.
//

import SwiftUI

import DesignSystem

struct EmptySearchView: View {
  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .center) {
        Image("categoryIcon1")
          .frame(width: 120, height: 120)
          .background(.gray)
        Text("최근 검색어가 아직 없어요")
          .font(.B1_M)
          .foregroundStyle(.caption3)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

#Preview {
  EmptySearchView()
}
