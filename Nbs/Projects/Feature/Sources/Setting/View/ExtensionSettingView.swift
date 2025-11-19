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

struct ExtensionSettingView: View {
  let store: StoreOf<ExtensionSettingFeature>
  @Environment(\.colorScheme) private var colorScheme
  @State private var isReady = false
}

extension ExtensionSettingView {
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      VStack(spacing: 16) {
        TopAppBarDefaultRightIconx(title: "Safari 익스텐션 허용하기") {
          store.send(.backButtonTapped)
        }
        
        VStack(spacing: 0) {
          Text("Safari 익스텐션을 허용해\n하이라이트와 메모 기능을 사용해보세요")
            .font(.B1_M)
            .foregroundStyle(.caption1)
            .multilineTextAlignment(.center)
          
          ZStack {
            ZStack(alignment: .center) {
              Color.background.ignoresSafeArea()
              VStack(alignment: .center, spacing: 8) {
                DesignSystemAsset.wifiOff.swiftUIImage
                  .resizable()
                  .scaledToFit()
                  .frame(width: 48, height: 48)
                
                Text("인터넷 연결이 불안정해요")
                  .font(.B2_M)
                  .foregroundStyle(.caption2)
                  .multilineTextAlignment(.center)
              }
            }
            .opacity(isReady ? 0 : 1)
      
            let url = (colorScheme == .dark)
                ? AppConfig.settingExtensionURL_dark
                : AppConfig.settingExtensionURL_light
            
            CustomVideoView(
              url: URL(string: url)!,
              onReady: { isReady = true }, videoGravity: .resizeAspectFill
            )
            .opacity(isReady ? 1: 0)
            .scaleEffect(1.02)
            .clipped()
            .frame(width: 300, height: 400)
            .padding(.bottom, 130)
          }
        }
        .padding(.horizontal, 20)
      }
    }
  }
}

#Preview {
  ExtensionSettingView(store: Store(initialState: ExtensionSettingFeature.State(), reducer: {
    ExtensionSettingFeature()
  }))
}
