// SplashView.swift
// Feature
//
//  Created by 신지현(Zigu) on 11/11/25.
//

import SwiftUI
import DesignSystem

public struct SplashView: View {
  @State private var leftScale: CGFloat = 1.0
  @State private var rightScale: CGFloat = 1.0
  
  public init() { }
}

extension SplashView {
  public var body: some View {
    ZStack {
      Color.bl6.ignoresSafeArea()
      
      VStack {
        Spacer()
        
        HStack(spacing: -4) {
          DesignSystemAsset.logoLeft.swiftUIImage
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.white)
            .scaledToFit()
            .frame(width: 50, height: 50)
            .scaleEffect(leftScale)
            .offset(y: 3)
          
          DesignSystemAsset.logoRight.swiftUIImage
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.white)
            .scaledToFit()
            .frame(width: 50, height: 50)
            .scaleEffect(rightScale)
            .offset(y: 3)
        }
        .padding(.bottom, 20)
        Spacer()
      }
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
        playAnimation()
      }
    }
  }
}

private extension SplashView {
  func playAnimation() {
    withAnimation(.interpolatingSpring(stiffness: 170, damping: 12)) {
      leftScale = 1.12
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
      withAnimation(.interpolatingSpring(stiffness: 170, damping: 12)) {
        leftScale = 0.95
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
      withAnimation(.interpolatingSpring(stiffness: 160, damping: 12)) {
        rightScale = 1.08
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
      withAnimation(.interpolatingSpring(stiffness: 160, damping: 12)) {
        rightScale = 0.97
      }
    }
  }
}

#Preview {
  SplashView()
}
