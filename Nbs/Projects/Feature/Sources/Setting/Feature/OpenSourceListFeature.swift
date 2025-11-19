//
//  OpenSourceListFeature.swift
//  Feature
//
//  Created by 이안 on 11/6/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

@Reducer
struct OpenSourceListFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable { }
  
  enum Action: Equatable {
    case backButtonTapped
    case libraryTapped(String)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .run { _ in await linkNavigator.pop() }
        
      case let .libraryTapped(url):
        if let link = URL(string: url) {
          UIApplication.shared.open(link)
        }
        return .none
      }
    }
  }
}
