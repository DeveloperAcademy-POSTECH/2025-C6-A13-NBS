//
//  SafariPIP.swift
//  Nbs
//
//  Created by 홍 on 10/24/25.
//

import SwiftUI

import DesignSystem
import Feature

struct SafariPIP: View {
  @State var showHome = false
  let title = "Safari 권한 설정하기"
  let dec = "실시간 하이라이트와 메모 기능을 사용하기 위해\nSafari 권한 설정을 함께 진행할게요"
  
  @StateObject private var pip: SimplePiPController = {
    guard let url = Bundle.main.url(forResource: "SafariSettingVideo1080", withExtension: "mov") else {
      fatalError("Video file not found")
    }
    return SimplePiPController(url: url)
  }()
  
  var body: some View {
    VStack {
      Text(title)
        .font(.H2)
        .foregroundStyle(.text1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
        .padding(.top, 24)
      
      Text(dec)
        .font(.C1)
        .foregroundStyle(.caption2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
      
      Spacer()
      
      Image(.settingVideo)
        .resizable()
        .frame(width: 300, height: 400)
      Spacer()
      
      Button(action: {
        pip.play()
        startPipThenOpenSetting()
      }) {
        Text("다음")
          .frame(maxWidth: .infinity)
          .padding()
          .font(.B1_SB)
          .background(DesignSystemAsset.bgBtn.swiftUIColor)
          .foregroundColor(.textw)
          .cornerRadius(12)
      }
      .padding(.horizontal, 20)
      .padding(.top, 32)
      
      Button {
        showHome = true
      } label: {
        Text("건너뛰기")
          .font(.C2)
          .foregroundStyle(.caption2)
          .underline()
      }
    }
    .fullScreenCover(isPresented: $showHome) {
      HomeEntryView()
    }
    .background(DesignSystemAsset.background.swiftUIColor)
  }
  
  private func startPipThenOpenSetting() {
    pip.play()
    
    // PiP 시작 후 설정으로 이동
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.pip.startPiP()
      
      // PiP가 시작된 후 설정 열기
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(url)
        }
      }
    }
  }
}

#Preview {
  SafariPIP()
}
