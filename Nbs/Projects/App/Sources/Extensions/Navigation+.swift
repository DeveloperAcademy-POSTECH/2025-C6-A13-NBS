//
//  Navigation+.swift
//  ActionExtension
//
//  Created by 이안 on 10/19/25.
//

import UIKit

/// 네비게이션 스와이프 제스처
extension UINavigationController: @retroactive ObservableObject, @retroactive
  UIGestureRecognizerDelegate
{

  /// 뷰가 로드될 때 호출되는 메서드
  override open func viewDidLoad() {
    super.viewDidLoad()
    // 스와이프 제스처(인터랙티브 팝 제스처)의 delegate를 현재 UINavigationController로 설정
    interactivePopGestureRecognizer?.delegate = self
  }

  /// 스와이프 제스처(뒤로 가기)가 시작되기 전에 실행되는 delegate 메서드
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
