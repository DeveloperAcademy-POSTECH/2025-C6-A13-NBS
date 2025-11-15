//
//  LottieView.swift
//  Nbs
//
//  Created by 홍 on 11/14/25.
//

import SwiftUI
import UIKit

import Lottie

struct LottieView: UIViewRepresentable {
  let fileName: String
  let loopMode: LottieLoopMode
  
  func makeUIView(context: Context) -> Lottie.LottieAnimationView {
    let animationView = LottieAnimationView(name: fileName)
    animationView.loopMode = loopMode
    //        animationView.contentMode = .scaleAspectFit
    animationView.play()
    return animationView
  }
  
  func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
