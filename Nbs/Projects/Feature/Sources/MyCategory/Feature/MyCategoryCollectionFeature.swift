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
    var settingModal: SettingFeature.State?
  }
  
  enum Action {
    case topAppBar(TopAppBarDefaultNoSearchFeature.Action)
    case categoryGrid(CategoryGridFeature.Action)
    case settingModal(SettingFeature.Action)
    case delegate(Delegate)
    
    enum Delegate {
      case addCategory
      case editCategory
      case deleteCategory
    }
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
        state.settingModal = SettingFeature.State()
        return .none

      case .categoryGrid(_):
        return .none
        
      case .settingModal(.dismissButtonTapped):
        state.settingModal = nil
        return .none
        
      case .settingModal(.addButtonTapped):
        return .send(.delegate(.addCategory))
      case .settingModal(.editButtonTapped):
        return .send(.delegate(.editCategory))
      case .settingModal(.deleteButtonTapped):
        return .send(.delegate(.deleteCategory))
      case .delegate(_):
        return .none
      }
    }
  }
}
