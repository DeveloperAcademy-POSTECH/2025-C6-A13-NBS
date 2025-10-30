//
//  OriginalArticleFeature.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct OriginalArticleFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable {
    var url: URL
  }
  
  enum Action: Equatable {
    case editButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .editButtonTapped:
        print("edit")
        linkNavigator.push(.originalEdit, state.url.absoluteString)
        return .none
      }
    }
  }
}
