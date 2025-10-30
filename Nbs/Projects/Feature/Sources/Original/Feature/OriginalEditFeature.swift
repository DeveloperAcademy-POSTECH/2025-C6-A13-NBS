//
//  OriginalEditFeature.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct OriginalEditFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable {
    var url: URL
  }
  
  enum Action: Equatable {
    case completeButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .completeButtonTapped:
        print("completed")
        return .none
      }
    }
  }
}
