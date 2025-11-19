//
//  EmptyLinkDetailView.swift
//  Feature
//
//  Created by 이안 on 10/27/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct EmptyLinkDetailView: View {
  var body: some View {
    VStack(alignment: .center, spacing: 8) {
      DesignSystemAsset.edit.swiftUIImage
        .resizable()
        .renderingMode(.template)
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(.bl4)
        .frame(width: 24, height: 24)
        .padding(.bottom, 8)
      
      Text("나의 요약본이 존재하지 않아요!")
        .font(.B1_SB)
        .foregroundStyle(.text1)
      
      Text("원문을 읽고 중요한 부분에\n하이라이트와 메모를 남겨보세요")
        .font(.C2)
        .foregroundStyle(.caption1)
        .multilineTextAlignment(.center)
    }
  }
}

#Preview {
  EmptyLinkDetailView()
}
