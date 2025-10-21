//
//  EditCategoryIconNameFeature.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture
import Domain

@Reducer
struct EditCategoryIconNameFeature {
  
  @Dependency(\.dismiss) var dismiss
  
  @ObservableState
  struct State: Equatable {
    var topAppBar = TopAppBarDefaultRightIconxFeature.State(title: "카테고리 수정하기")
    var categoryName: String = ""
//    var categoryIcon: CategoryIcon
    var categoryGrid = CategoryGridFeature.State()
//    var selectedCategory: CategoryItem?
  }
  
  enum Action {
    case categoryGrid(CategoryGridFeature.Action)
    case compeleteButtonTapped
    case topAppBar(TopAppBarDefaultRightIconxFeature.Action)
    case setCategoryName(String)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.categoryGrid, action: \.categoryGrid) {
      CategoryGridFeature()
    }
    
    Scope(state: \.topAppBar, action: \.topAppBar) {
      TopAppBarDefaultRightIconxFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .categoryGrid(.delegate(.categorySelected(let category))):
//        state.selectedCategory = category
        return .none
      case .categoryGrid(.onAppear):
        return .none
      case .categoryGrid(.fetchCategoriesResponse(_)):
        return .none
      case let .setCategoryName(name):
        state.categoryName = name
        return .none
      case .categoryGrid(.selectCategory(_)):
        return .none
      case let .setCategoryName(name):
        state.categoryName = name
        return .none
      case .compeleteButtonTapped:
        return .run { _ in
          await self.dismiss()
        }
      case .topAppBar(.tapBackButton):
        return .run { _ in await self.dismiss() }
      }
    }
  }
}
