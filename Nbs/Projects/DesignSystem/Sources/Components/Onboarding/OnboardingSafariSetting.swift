//
//  OnboardingSafariSetting.swift
//  DesignSystem
//
//  Created by 홍 on 11/25/25.
//

import SwiftUI

public struct OnboardingSafariSetting {
  @Binding var currentPage: Int
  let showPage: Bool = true
  let settingDescription: [String] = [
    "1.  설정 > Safari에서 확장 프로그램을 선택해주세요",
    "2.  탭탭 > 확장 프로그램 ‘탭탭'을 선택해주세요",
    "3.  확장 프로그램을 ‘허용' 해주세요",
    "4.  모든 웹사이트를 ‘허용' 해주세요"
  ]
  
  let settingImages: [Image] = [
    DesignSystemAsset.onboardingSafari1.swiftUIImage,
    DesignSystemAsset.onboardingSafari2.swiftUIImage,
    DesignSystemAsset.onboardingSafari3.swiftUIImage,
    DesignSystemAsset.onboardingSafari4.swiftUIImage
  ]
  
 public init(currentPage: Binding<Int>) {
   self._currentPage = currentPage
  }
}

extension OnboardingSafariSetting: View {
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 8) {
        Text("Safari 권한 설정하기")
          .font(.H2)
          .foregroundStyle(.text1)
        if showPage {
          Text("\(1)/\(3)")
            .font(.C2)
            .foregroundStyle(.caption1)
            .offset(y: 5)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 20)
      
      Text("실시간 하이라이트와 메모 기능을 사용하기 위해")
        .font(.C1)
        .foregroundStyle(.caption2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
        .padding(.top, 8)
      
      HStack {
        Text("설정 > Safari")
          .font(.B1_SB)
          .foregroundStyle(.caption1)
        Text("에서 권한 설정을 함께 진행할게요")
          .font(.C1)
          .foregroundStyle(.caption2)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 20)
      
      TabView(selection: $currentPage) {
        ForEach(settingDescription.indices, id: \.self) { index in
          VStack(spacing: 0) {
            Text(settingDescription[index])
              .font(.B1_SB)
              .foregroundStyle(.text1)
              .multilineTextAlignment(.center)
              .padding(.bottom, 20)
            
            settingImages[index]
              .resizable()
              .scaledToFit()
              .frame(height: 323)
              .padding(.horizontal, 20)
          }
          .tag(index)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .frame(height: 367)
      .padding(.top, 55)
      
      PageControl(numberOfPages: 4, currentPage: $currentPage)
        .padding(.top, 40)
    }
    .background(Color.background)
  }
}

//#Preview {
//  OnboardingSafariSetting()
//}
