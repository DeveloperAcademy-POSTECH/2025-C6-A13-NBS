//
//  simplePi.swift
//  Feature
//
//  Created by 홍 on 11/25/25.
//

import AVFoundation
import AVKit
import Combine

public final class SimplePiPController: NSObject, ObservableObject {
  public let url: URL
  
  public var player: AVPlayer!
  public var playerLayer: AVPlayerLayer!
  public var pipController: AVPictureInPictureController?
  public var pipWindow: UIWindow? // 추가: PiP를 위한 hidden window
  
  @Published public var pipSupported = false
  @Published public var pipActive = false
  
  public init(url: URL) {
    self.url = url
    super.init()
    configure()
  }
  
  private func configure() {
    let session = AVAudioSession.sharedInstance()
    try? session.setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
    try? session.setActive(true)
    
    let item = AVPlayerItem(url: url)
    player = AVPlayer(playerItem: item)
    player.isMuted = true
    playerLayer = AVPlayerLayer(player: player)
    playerLayer.videoGravity = .resizeAspect
    
    // playerLayer를 실제로 화면에 추가 (hidden window 사용)
    setupHiddenWindow()
    
    if AVPictureInPictureController.isPictureInPictureSupported() {
      pipController = AVPictureInPictureController(playerLayer: playerLayer)
      pipController?.delegate = self
      pipSupported = true
    } else {
      pipSupported = false
    }
  }
  
  private func setupHiddenWindow() {
    // PiP를 위한 숨겨진 윈도우 생성
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
      window.isHidden = false
      window.alpha = 0.01 // 거의 보이지 않게
      
      let viewController = UIViewController()
      viewController.view.layer.addSublayer(playerLayer)
      playerLayer.frame = viewController.view.bounds
      
      window.rootViewController = viewController
      window.makeKeyAndVisible()
      
      self.pipWindow = window
    }
  }
}

// MARK: - Method
extension SimplePiPController {
  public func play() {
    player.play()
  }
  
  public func startPiP() {
    guard pipSupported, let pip = pipController else { return }
    
    // PiP 시작 전 플레이어가 재생 중인지 확인
    if player.timeControlStatus != .playing {
      player.play()
    }
    
    // 약간의 지연 후 PiP 시작
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      pip.startPictureInPicture()
    }
  }
  
  public func stopPiP() {
    pipController?.stopPictureInPicture()
    pipWindow = nil // 윈도우 정리
  }
}

// MARK: - Delegate
extension SimplePiPController: AVPictureInPictureControllerDelegate {
  public func pictureInPictureControllerWillStartPictureInPicture(_ controller: AVPictureInPictureController) {
    pipActive = true
  }
  
  public func pictureInPictureControllerDidStopPictureInPicture(_ controller: AVPictureInPictureController) {
    pipActive = false
    player.pause()
    player.seek(to: .zero)
  }
}
