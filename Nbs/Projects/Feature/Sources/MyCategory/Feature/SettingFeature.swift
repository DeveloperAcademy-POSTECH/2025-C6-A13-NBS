
//
//  SettingFeature.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import SwiftUI

import ComposableArchitecture

@Reducer
struct SettingFeature {
  @ObservableState
  struct State: Equatable {
    var message: String = "Hello from Setting Sheet!"
  }

  enum Action {
    case dismissButtonTapped
  }

  @Dependency(\.dismiss) var dismiss

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .dismissButtonTapped:
        return .none
      }
    }
  }
}
