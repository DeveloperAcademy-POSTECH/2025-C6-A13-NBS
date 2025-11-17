//
//  LottieWrapperView.swift
//  DesignSystem
//
//  Created by 여성일 on 11/17/25.
//

import SwiftUI
import UIKit
import Lottie

public struct LottieWrapperView: UIViewRepresentable {
  let animationName: String
  let loopMode: LottieLoopMode
  
  public init(animationName: String, loopMode: LottieLoopMode = .playOnce) {
    self.animationName = animationName
    self.loopMode = loopMode
  }
  
  public func makeUIView(context: Context) -> UIView {
    let view = UIView(frame: .zero)
    
    let animationView = LottieAnimationView(name: animationName)
    animationView.loopMode = loopMode
    animationView.contentMode = .scaleAspectFit
    
    animationView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(animationView)
    
    NSLayoutConstraint.activate([
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
    ])
    
    animationView.play()
    return view
  }
  
  public func updateUIView(_ uiView: UIView, context: Context) {
    
  }
}

