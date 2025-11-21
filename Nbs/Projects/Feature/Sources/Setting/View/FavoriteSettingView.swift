//
//  FavoriteSettingView.swift
//  Feature
//
//  Created by 이안 on 11/12/25.
//

import SwiftUI
import AVKit

import ComposableArchitecture
import DesignSystem

struct FavoriteSettingView: View {
  let store: StoreOf<FavoriteSettingFeature>
  @State private var isReady = false
}

extension FavoriteSettingView {
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      VStack(spacing: 16) {
        TopAppBarDefaultRightIconx(title: "즐겨찾기 설정하기") {
          store.send(.backButtonTapped)
        }
        
        VStack(spacing: 30) {
          Text("탭탭을 즐겨찾기 설정하여\n더 쉽게 공유할 수 있어요!")
            .font(.B1_M)
            .foregroundStyle(.caption1)
            .multilineTextAlignment(.center)
          
          ZStack {
            ZStack(alignment: .center) {
              Color.background.ignoresSafeArea()
              Image(systemName: "progress.indicator")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            }
            .opacity(isReady ? 0 : 1)
            
            CustomVideoView(
              url: URL(string: AppConfig.settingFavoriteURL)!,
              onReady: { isReady = true }, videoGravity: .resizeAspectFill
            )
            .opacity(isReady ? 1: 0)
            .cornerRadius(32)
            .clipped()
            .overlay {
              RoundedRectangle(cornerRadius: 32)
                .stroke(Color.divider2, lineWidth: 3)
            }
            .padding(14)
          }
        }
        .padding(.horizontal, 52)
      }
    }
  }
}

#Preview {
  FavoriteSettingView(
    store: Store(
      initialState: FavoriteSettingFeature.State(),
      reducer: {
        FavoriteSettingFeature()
      }))
}
