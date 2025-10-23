//
//  Video.swift
//  Nbs
//
//  Created by 홍 on 10/24/25.
//

import SwiftUI
import AVKit

struct VideoView: UIViewRepresentable {
  let playerLayer: AVPlayerLayer
  
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    view.layer.addSublayer(playerLayer)
    playerLayer.frame = view.bounds
    playerLayer.videoGravity = .resizeAspect
    return view
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
    playerLayer.frame = uiView.bounds
  }
}
