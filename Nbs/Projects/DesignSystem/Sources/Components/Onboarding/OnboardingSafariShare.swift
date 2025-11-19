//
//  OnboardingSafariShare.swift
//  DesignSystem
//
//  Created by 홍 on 11/12/25.
//

import SwiftUI

public struct OnboardingSafariShare {
  public init() {}
}

extension OnboardingSafariShare: View {
  public var body: some View {
    HStack(spacing: 10) {
      VStack {
        Text("Safari에서 공유하기")
          .font(.B2_SB)
          .foregroundStyle(.bl6)
        
        VStack(spacing: 0) {
          Group {
            Text("하이라이트와 메모가")
              .padding(.top, 24)
            Text("모두 저장돼요")
          }
          .font(.B2_M)
          .foregroundStyle(.caption1)
          
          DesignSystemAsset.safariShareLight.swiftUIImage
            .resizable()
            .frame(width: 132, height: 200)
            .padding(.horizontal)
            .padding(.vertical)
        }
        .background(.bl1)
        .clipShape(RoundedRectangle(cornerRadius: 16))
      }
      
      VStack {
        Text("탭탭에서 추가하기")
          .font(.B2_SB)
          .foregroundStyle(.caption1)
        
        VStack(spacing: 0) {
          Group {
            Text("하이라이트와 메모 없이")
              .padding(.top, 24)
            Text("링크 주소만 저장돼요")
          }
          .font(.B2_M)
          .foregroundStyle(.caption1)
          
          DesignSystemAsset.safariShare.swiftUIImage
            .resizable()
            .frame(width: 132, height: 200)
            .padding(.horizontal)
            .padding(.vertical)
        }
        .background(Color.c14)
        .clipShape(RoundedRectangle(cornerRadius: 16))
      }
    }
  }
}

#Preview {
  OnboardingSafariShare()
}
