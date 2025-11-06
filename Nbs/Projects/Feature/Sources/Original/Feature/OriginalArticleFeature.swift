//
//  OriginalArticleFeature.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import ComposableArchitecture
import Foundation
import Domain

@Reducer
struct OriginalArticleFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable {
    var url: URL
    var highlights: [HighlightItem]
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
