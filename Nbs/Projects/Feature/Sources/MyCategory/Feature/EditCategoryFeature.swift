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
//  let naviagtor: SingleLinkNavigator
  
  @ObservableState
  struct State: Equatable {
    var naviTitle: String = "수정할 카테고리를 입력해주세요."
    var categoryGrid = CategoryGridFeature.State(allowsMultipleSelection: false)
    var selectedCategory: CategoryItem?
  }
  
  enum Action {
    case categoryGrid(CategoryGridFeature.Action)
    case cancelButtonTapped
    case editButtonTapped
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
      }
    }
  }
}
