//
//  MyCategoryCollectionFeature.swift
//  Feature
//
//  Created by 홍 on 10/20/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct MyCategoryCollectionFeature {
  
  @Dependency(\.dismiss) var dismiss
  
  @ObservableState
  struct State: Equatable {
    var topAppBar = TopAppBarDefaultNoSearchFeature.State(title: CategoryNamespace.myCategoryCollection)
    var categoryGrid = CategoryGridFeature.State()
    var selectedCategory: CategoryItem?
  }
  
  enum Action {
    case topAppBar(TopAppBarDefaultNoSearchFeature.Action)
    case categoryGrid(CategoryGridFeature.Action)
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  var body: some ReducerOf<Self> {
    Scope(state: \.topAppBar, action: \.topAppBar) {
      TopAppBarDefaultNoSearchFeature()
    }
    
    Scope(state: \.categoryGrid, action: \.categoryGrid) {
      CategoryGridFeature()
    }
    Reduce { state, action in
      switch action {
      case .topAppBar(.tapBackButton):
        return .run { _ in
          await self.dismiss()
        }
        
      case .topAppBar(.tapSettingButton):
        return .none
      case .categoryGrid(_):
        return .none
      }
    }
  }
}
