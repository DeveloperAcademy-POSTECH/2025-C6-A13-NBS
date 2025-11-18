//
//  OnboardingSafariShareView.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct OnboardingSafariShareView {
  let store: StoreOf<OnboardingSafariShareFeature>
}

extension OnboardingSafariShareView: View {
  var body: some View {
    VStack(spacing: 0) {
      TopAppBarDefaultRightIconx(title: "") {
        store.send(.backButtonTapped)
      }
      VStack(spacing: 0) {
        HStack(spacing: 8) {
          Text("Safari에서 작성한 내용 공유하기")
            .font(.H2)
            .foregroundStyle(.text1)
            Text("\(3)/\(3)")
              .font(.C2)
              .foregroundStyle(.caption1)
              .offset(y: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
        
        Text("하이라이트와 메모를 함께 저장하기 위해")
          .font(.C1)
          .foregroundStyle(.caption2)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 20)
          .padding(.top, 8)
        
        Text("Safari에서 바로 공유를 권장해요")
          .font(.B1_SB)
          .foregroundStyle(.caption2)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 20)
      }
      
      OnboardingSafariShare()
        .padding(.top, 60)
        .padding(.horizontal, 20)
      
      Spacer()
      VStack(spacing: 0) {
        MainButton("다음", hasGradient: true) {
          store.send(.nextButtonTapped)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 24)
        
        Button(action: {
          store.send(.skipButtonTapped)
        }) {
          Text("건너뛰기")
            .font(.C2)
            .foregroundStyle(.caption2)
            .underline()
        }
      }
      .background(Color.background)
      .padding(.bottom, 8)
    }
    .background(Color.background)
    .toolbar(.hidden)
  }
}
