//
//  OnboardingSafariSetting.swift
//  Nbs
//
//  Created by 홍 on 11/7/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct OnboardingView {
  @Bindable var store: StoreOf<OnboardingFeature>
  @Environment(\.colorScheme) private var colorScheme
  
  @State private var pip: SimplePiPController?
}

extension OnboardingView: View {
  var body: some View {
    VStack(spacing: 0) {
      OnboardingTitleImage(
        title: .safariTitle,
        description: .safariDescription,
        image: DesignSystemAsset.safariSetting.swiftUIImage,
        showPage: true,
        currentPage: store.currentPage
      )
      .padding(.top, 72)
      Spacer()
      VStack(spacing: 0) {
        MainButton("설정하기", hasGradient: true) {
          store.send(.settingButtonTapped)
//          pip.play()
          startPipThenOpenSetting()
        }
        .buttonStyle(.plain)
        
        Button(action: {
          store.send(.skipButtonTapped)
        }) {
          Text("건너뛰기")
            .font(.C2)
            .foregroundStyle(.caption2)
            .underline()
        }
        .padding(.top, 24)
      }
      .background(Color.background)
    }
    .background(Color.background)
    .toolbar(.hidden)
    .overlay {
      if store.isAlert {
        ZStack {
          Color.dim.ignoresSafeArea()
          AlertDialog(
            title: "Safari 권한 설정을 건너뛸까요?",
            subtitle: "권한을 설정하지 않으면\n제공하는 기능 사용이 제한돼요",
            cancelTitle: "취소",
            onCancel: { store.send(.alertCancelButtonTapped) },
            buttonType: .move(title: "건너뛰기", action: { store.send(.alertSkipButtonTapped) })
          )
        }
      }
    }
  }
}

extension OnboardingView {
  private func startPipThenOpenSetting() {
    let videoName = (colorScheme == .dark) ? "safariSettingDark" : "safariSettingLight"
    
    guard let url = Bundle.main.url(forResource: videoName, withExtension: "mov") else {
      print("⚠️ video not found: \(videoName)")
      return
    }
    
    // ✅ pip이 없으면 새로 생성
    if pip == nil {
      pip = SimplePiPController(url: url)
    } else {
      
    }
    
    pip?.play()
    
    DispatchQueue.main.asyncAfter(deadline: .now()) {
      self.pip?.startPiP()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(url)
        }
      }
    }
  }
}
