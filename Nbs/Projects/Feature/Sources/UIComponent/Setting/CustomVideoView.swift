//
//  CustomVideoView.swift
//  Feature
//
//  Created by 이안 on 11/12/25.
//

import SwiftUI
import AVKit

public struct CustomVideoView: UIViewControllerRepresentable {
  let url: URL
  var onReady: (() -> Void)? = nil
  var videoGravity: AVLayerVideoGravity = .resizeAspectFill
  
  public init(url: URL, onReady: (() -> Void)? = nil, videoGravity: AVLayerVideoGravity) {
    self.url = url
    self.onReady = onReady
    self.videoGravity = videoGravity
  }
  
  public func makeUIViewController(context: Context) -> AVPlayerViewController {
    let controller = AVPlayerViewController()
    let player = AVPlayer(url: url)
    player.isMuted = true
    
    controller.player = player
    
    try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
    try? AVAudioSession.sharedInstance().setActive(false)
    
    /// 비율 유지하며 화면 꽉 채우기
    controller.videoGravity = .resizeAspectFill
    
    /// 플레이어 컨트롤러(일시정지, 스크럽바 등) 숨기기
    controller.showsPlaybackControls = false
    
    /// 사용자 인터랙션 차단 (터치 불가능)
    controller.view.isUserInteractionEnabled = false
    
    controller.videoGravity = videoGravity
    controller.view.backgroundColor = .clear
    
    /// 반복 재생 설정
    NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: player.currentItem,
      queue: .main
    ) { _ in
      player.seek(to: .zero)
      player.play()
    }
    
    player.currentItem?.addObserver(
      context.coordinator,
      forKeyPath: "status",
      options: [.new],
      context: nil
    )
    context.coordinator.onReady = onReady
    context.coordinator.player = player
    
    return controller
  }
  
  public func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
  
  public func makeCoordinator() -> Coordinator { Coordinator() }
   
  public class Coordinator: NSObject {
       var player: AVPlayer?
       var onReady: (() -> Void)?
       
       public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           if keyPath == "status",
              let item = object as? AVPlayerItem,
              item.status == .readyToPlay {
               player?.play()
               onReady?()
           }
       }
   }
}
