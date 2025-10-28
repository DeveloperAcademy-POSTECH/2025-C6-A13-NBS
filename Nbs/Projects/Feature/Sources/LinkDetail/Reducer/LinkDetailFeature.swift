//
//  LinkDetailFeature.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct LinkDetailFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State: Equatable {
//    var id: String { link.id }
    var link: ArticleItem
  }
  
  enum Action {
    case onAppear
    case refreshHighlights
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
        
      case .refreshHighlights:
        return .none
      }
    }
  }
}
