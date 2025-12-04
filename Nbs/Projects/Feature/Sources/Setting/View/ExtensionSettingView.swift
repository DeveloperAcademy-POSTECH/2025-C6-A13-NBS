//
//  ExtensionSettingView.swift
//  Feature
//
//  Created by 이안 on 11/12/25.
//

import SwiftUI
import AVKit

import ComposableArchitecture
import DesignSystem

struct ExtensionSettingView {
  @Bindable var store: StoreOf<ExtensionSettingFeature>
  @State private var videoChecked: Bool = false
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.scenePhase) private var scenePhase
  @State private var currentPage: Int = 0
  @State private var pip: SimplePiPController?
  
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

}

extension ExtensionSettingView: View {
  var body: some View {
    VStack(spacing: 0) {
      TopAppBarDefaultRightIconx(title: "Safari 익스텐션 허용하기") {
        store.send(.backButtonTapped)
      }
      VStack(spacing: 0) {
        Group {
          Text("Safari 익스텐션을 허용해")
          Text("하이라이트와 메모 기능을 사용해보세요")
        }
        .font(.B1_M)
        .foregroundStyle(.caption1)
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
        .padding(.top, 45)
        
        OnboardingPageControl(numberOfPages: 4, currentPage: $currentPage)
          .padding(.top, 40)
      }
      .padding(.top)
      .padding(.horizontal, 20)
      Spacer()
        MainButton2(
          "설정하기",
          style: .deep,
          hasGradient: false
        ) {
          store.send(.settingButtonTapped)
          startPipThenOpenSetting()
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
    .background(Color.background)
    .toolbar(.hidden)
  }
}

extension ExtensionSettingView {
  private func startPipThenOpenSetting() {
    let videoName = (colorScheme == .dark) ? "safariSettingDark" : "safariSettingLight"
    videoChecked = true
    guard
      let url = Bundle.main.url(forResource: videoName, withExtension: "MP4")
    else {
      print("video not found: \(videoName)")
      return
    }
    
    if pip == nil {
      pip = SimplePiPController(url: url)
    } else {
      
    }
    
    pip?.play()
    
    DispatchQueue.main.asyncAfter(deadline: .now()) {
      self.pip?.startPiP()
      
      DispatchQueue.main.asyncAfter(deadline: .now()) {
        if let url = URL(string: "App-prefs:SAFARI") {
          UIApplication.shared.open(url)
        }
      }
    }
  }
}

struct OnboardingPageControl: View {
  
  var numberOfPages: Int
  @Binding var currentPage: Int
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(0..<numberOfPages, id: \.self) { pagingIndex in
        
        let isCurrentPage = currentPage == pagingIndex
        let height = 8.0
        let width = isCurrentPage ? height * 2 : height
        
        Capsule()
          .fill(
            isCurrentPage ? .bl6 : .bl3.opacity(0.7)
          )
          .frame(width: width, height: height)
      }
    }
    .animation(.linear, value: currentPage)
  }
}
