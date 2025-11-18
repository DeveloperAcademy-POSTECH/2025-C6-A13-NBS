//
//  TipCardView.swift
//  Feature
//
//  Created by 홍 on 10/29/25.
//

import SwiftUI

import DesignSystem

struct TipCardView {
  let buttonTap: () -> Void
  let closeTap: () -> Void
}

extension TipCardView: View {
  var body: some View {
    ZStack(alignment: .topTrailing) {
      VStack(spacing: 0) {
        Text("Safari에서 바로 메모하고\n링크를 남겨보세요")
          .font(.H3)
          .foregroundStyle(.text1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 20)
          .padding(.top, 20)
        
        Text("저장한 내용은 이곳에서 한눈에 볼 수 있어요")
          .font(.B2_M)
          .foregroundStyle(.caption1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 20)
        
        DesignSystemAsset.tipImage.swiftUIImage
          .resizable()
          .frame(width: 300, height: 160)
          .padding(.top, 40)
        
        MainButton("사용 팁 보러가기 →") {
          buttonTap()
        }
        .padding(.top, 40)
        .padding(.bottom, 24)
      }
      .background(.bl2)
      Button {
        closeTap()
      } label: {
        Image(icon: Icon.x)
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(.iconGray)
          .frame(width: 24, height: 24)
          .frame(width: 44, height: 44)
          .contentShape(Rectangle())
          .padding(.trailing, 6)
      }
      .padding(.top, 12)
    }
  }
}

#Preview {
  TipCardView() {
    
  } closeTap: {
    
  }
}
