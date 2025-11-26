//
//  OnboardingSafariSetting.swift
//  Nbs
//
//  Created by 홍 on 11/7/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem
import Feature

struct OnboardingView {
  @Bindable var store: StoreOf<OnboardingFeature>
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.scenePhase) private var scenePhase
  @State private var currentPage: Int = 0
  @State private var pip: SimplePiPController?
  @State private var videoChecked: Bool = false
}

extension OnboardingView: View {
  var body: some View {
    VStack(spacing: 0) {
      OnboardingSafariSetting(currentPage: $currentPage)
      .padding(.top, 60)
      Spacer()
      HStack(spacing: 8) {
        MainButton2(
          "설정하기",
          style: .soft,
          hasGradient: false
        ) {
          store.send(.settingButtonTapped)
          startPipThenOpenSetting()
        }
        .buttonStyle(.plain)
        
        MainButton2("다음", isDisabled: currentPage != 3) {
          store.send(.nextButtonTapped)
        }
        .buttonStyle(.plain)
      }
      .background(Color.background)
      .padding(.bottom, 8)
      .padding(.horizontal, 20)
    }
    .background(Color.background)
    .toolbar(.hidden)
    .overlay {
      if store.isAlert && !store.videoChecked {
        ZStack {
          Color.dim.ignoresSafeArea()
          AlertDialog(
            title: "Safari 권한 허용을 확인해주세요",
            subtitle: "권한을 설정하지 않으면\n제공하는 기능 사용이 제한돼요!",
            cancelTitle: "취소",
            onCancel: { store.send(.alertCancelButtonTapped) },
            buttonType: .move(title: "확인", action: { store.send(.alertSkipButtonTapped) })
          )
          .offset(y: 4)
        }
      }
    }
    .onChange(of: scenePhase) { _, newValue in
      if newValue == .active && store.videoChecked {
        store.send(.naviPush)
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
}

extension OnboardingView {
  private func startPipThenOpenSetting() {
    let videoName = (colorScheme == .dark) ? "safariSettingDark" : "safariSettingLight"
    store.send(.showVideo)
    guard
      let url = Bundle.main.url(forResource: videoName, withExtension: "MP4")
    else {
      print("비디오 찾을 수 없음: \(videoName)")
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
