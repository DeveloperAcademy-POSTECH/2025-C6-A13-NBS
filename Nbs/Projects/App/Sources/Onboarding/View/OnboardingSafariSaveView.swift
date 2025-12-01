//
//  OnboardingSaveView.swift
//  Nbs
//
//  Created by 홍 on 11/9/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem
import Feature

struct OnboardingSafariSaveView {
  var store: StoreOf<OnboardingSafariSaveFeature>
  @State private var isReady: Bool = false
}

//TODO: 다시 만들기
extension OnboardingSafariSaveView: View {
  var body: some View {
    ZStack(alignment: .bottom) {
      Color.background.ignoresSafeArea()
      VStack(spacing: 16) {
        TopAppBarDefaultRightIconx(
          title: "Safari에서 공유하기"
        ) {
          store.send(.backButtonTapped)
        }
        
        VStack(spacing: 30) {
          Text("Safari에서 공유해 저장하는 과정을\n영상을 통해 확인해보세요")
            .font(.B1_M)
            .foregroundStyle(.caption1)
            .multilineTextAlignment(.center)
            .padding(.top, 28)
          
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
              url: URL(string: AppConfig.settingShareURL)!,
              onReady: { isReady = true },
              videoGravity: .resizeAspect
            )
            .frame(width: 279, height: 450)
            .opacity(isReady ? 1: 0)
            .clipped()
            .cornerRadius(42)
            .overlay {
              RoundedRectangle(cornerRadius: 42)
                .stroke(Color.divider2, lineWidth: 3)
                .offset(y: -2)
            }
            .padding(.horizontal, 20)
            .overlay(
              Rectangle()
                .foregroundStyle(.clear)
                .background(
                  LinearGradient(
                    stops: [
                      Gradient.Stop(color: .bgButtonGrad1, location: 0.00),
                      Gradient.Stop(color: .bgButtonGrad2, location: 0.16),
                      Gradient.Stop(color: .bgButtonGrad3, location: 0.73),
                      Gradient.Stop(color: .bgButtonGrad4, location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.47, y: 0.1),
                    endPoint: UnitPoint(x: 0.47, y: 0.15)
                  )
                )
                .offset(y: -10)
            )
            .padding(.bottom, 130)
          }
        }
      }
      MainButton("완료") {
        store.send(.completeButtonTapped)
      }
      .padding(.bottom, 8)
    }
  }
}
