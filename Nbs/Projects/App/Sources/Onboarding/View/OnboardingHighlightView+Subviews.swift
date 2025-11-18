//
//  OnboardingHighlightView+Subviews.swift
//  Nbs
//
//  Created by 홍 on 11/14/25.
//

import SwiftUI
import DesignSystem

extension OnboardingHighlightView {
  
  var articleScriptHeader: some View {
    VStack(spacing: 0) {
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 24)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.leading, 20)
        .padding(.trailing, 80)
        .frame(height: 24)
        .padding(.top, 8)
      
      Text("스크롤을 멈추고 눈에 들어온 한 문장을 표시하는, 그")
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 48)
      
      Text("작은 행동이 정보를 지식으로 바꾸는 시작점이 됩니다.")
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
  }
  var articleScript3: some View {
    VStack(spacing: 10) {
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.trailing, 220)
        .padding(.leading, 20)
        .frame(height: 16)
    }
  }
  var articleScript2: some View {
    VStack(spacing: 10) {
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.leading, 20)
        .padding(.trailing, 100)
        .frame(height: 16)
    }
  }
  var articleScript: some View {
    VStack(spacing: 10) {
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .frame(height: 16)
      
      Rectangle()
        .fill(.n40)
        .frame(maxWidth: .infinity)
        .padding(.leading, 20)
        .padding(.trailing, 170)
        .frame(height: 16)
    }
  }
}
