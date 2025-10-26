
//
//  HomeEntryView.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import SwiftUI

import ComposableArchitecture
import LinkNavigator

/// App 모듈과 같이 외부 모듈에서 Home 기능을 사용하기 위한 진입점(Entry Point) 역할을 하는 View입니다.
/// 내부적으로 HomeFeature의 Store를 생성하고 관리하여, 외부에서는 복잡한 초기화 과정 없이 사용할 수 있습니다.
public struct HomeEntryView: View {
  private let store: StoreOf<HomeFeature>
  let navigator: SingleLinkNavigator
  
  public init(navigator: SingleLinkNavigator) {
    self.navigator = navigator
    self.store = Store(initialState: HomeFeature.State()) {
      HomeFeature()
        .dependency(\.linkNavigator, .init(navigator: navigator))
    }
  }
  
  public var body: some View {
    HomeView(navigator: navigator, store: store)
  }
}
