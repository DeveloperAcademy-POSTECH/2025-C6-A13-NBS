//
//  SafariInfoView.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import SwiftUI

import DesignSystem

struct SafariInfoView: View {
  let onConfirm: () -> Void
  @State var isOn: Bool = false
  
  var body: some View {
    VStack(spacing: 0) {
      Text("링크 자체 추가 시, 주의 사항")
        .font(.B1_SB)
        .foregroundStyle(.text1)
        .padding(.top, 28)
        .padding(.bottom, 20)
      Text("하이라이트와 메모를 함께 저장하기 위해")
        .font(.C1)
        .foregroundStyle(.caption1)
      Text("Safari에서 바로 공유를 권장해요")
        .font(.B1_SB)
        .foregroundStyle(.caption1)
      OnboardingSafariShare()
        .padding(.top, 48)
        .padding(.horizontal, 20)
      Button {
        isOn.toggle()
      } label: {
        HStack(spacing: 8) {
          Image(icon: isOn ? Icon.checkFill : Icon.checkUnfill)
            .resizable()
            .scaledToFit()
            .frame(width: 15, height: 15)
          Text("다시 보지 않기")
            .font(.B2_M)
            .foregroundStyle(.caption1)
        }
      }
      .frame(height: 32)
      .padding(.vertical, 24)

      MainButton("확인했어요", hasGradient: true) {
        if isOn {
          UserDefaults.standard.set(true, forKey: "safariInfo")
        }
        onConfirm()
      }
      .padding(.bottom, 40)
    }
    .background(Color.background)
  }
}

#Preview {
  SafariInfoView(onConfirm: {})
}
