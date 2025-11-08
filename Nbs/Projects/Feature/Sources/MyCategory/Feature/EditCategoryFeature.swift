//
//  EditCategoryFeature.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture
import Domain
import LinkNavigator

@Reducer
struct EditCategoryFeature {
  
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable {
    var categoryGrid = CategoryGridFeature.State(allowsMultipleSelection: false)
    var selectedCategory: CategoryItem?
    var topAppBar = TopAppBarDefaultRightIconxFeature.State(title: "카테고리 수정하기")
  }
  
  enum Action {
    case categoryGrid(CategoryGridFeature.Action)
    case cancelButtonTapped
    case editButtonTapped
    case topAppBar(TopAppBarDefaultRightIconxFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.categoryGrid, action: \.categoryGrid) {
      CategoryGridFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .categoryGrid(.delegate(.toggleCategorySelection(let category))):
        state.selectedCategory = category
        return .none
      case .categoryGrid(.onAppear):
        return .none
      case .categoryGrid(.fetchCategoriesResponse(_)):
        return .none
      case .categoryGrid(.toggleCategorySelection(_)):
        return .none
      case .cancelButtonTapped:
        return .run { _ in await linkNavigator.pop() }
      case .editButtonTapped:
        guard
          let category = state.selectedCategory
        else { return .none }
        linkNavigator.push(.editCategoryNameIcon, category)
        return .none
      case .topAppBar(.tapBackButton):
        return .run { _ in await linkNavigator.pop() } 
      case .topAppBar(_):
        return .none
      }
    }
  }
}
