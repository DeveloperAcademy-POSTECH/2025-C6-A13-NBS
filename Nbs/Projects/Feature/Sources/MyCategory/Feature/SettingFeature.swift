
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
  
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable {
    
  }

  enum Action {
    case dismissButtonTapped
    case addButtonTapped
    case editButtonTapped
    case deleteButtonTapped
  }

  @Dependency(\.dismiss) var dismiss

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .dismissButtonTapped:
        return .none
      case .addButtonTapped:
        return .none
      case .editButtonTapped:
        return .none
      case .deleteButtonTapped:
        return .none
      }
    }
  }
}
