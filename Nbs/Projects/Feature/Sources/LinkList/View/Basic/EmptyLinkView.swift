//
//  EmptyLinkView.swift
//  Feature
//
//  Created by 이안 on 10/27/25.
//

import SwiftUI
import DesignSystem

struct EmptyLinkView: View {
  var body: some View {
    VStack(alignment: .center, spacing: 20) {
      Spacer()
      DesignSystemAsset.emptyImage.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 120, height: 120)
      
      Text("아직 저장한 링크가 없어요")
        .font(.B1_M)
        .foregroundStyle(.caption3)
    }
  }
}
