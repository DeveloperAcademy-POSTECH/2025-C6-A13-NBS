//
//  DeleteCategoryFeature.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture
import Domain

@Reducer
struct DeleteCategoryFeature {
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State: Equatable {
    var naviTitle: String = "삭제할 카테고리를 입력해주세요."
    var categoryGrid = CategoryGridFeature.State(allowsMultipleSelection: true)
    var selectedCategories: Set<CategoryItem> = []
  }
  
  enum Action {
    case categoryGrid(CategoryGridFeature.Action)
    case cancelButtonTapped
    case deleteButtonTapped
    case toggleCategorySelection(CategoryItem)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.categoryGrid, action: \.categoryGrid) {
      CategoryGridFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .categoryGrid(.delegate(.toggleCategorySelection(let category))):
        state.selectedCategories.toggle(category)
        return .none
      case .categoryGrid(.onAppear):
        return .none
      case .categoryGrid(.fetchCategoriesResponse(_)):
        return .none
//      case .categoryGrid(.selectCategory(_)):
//        return .none
      case .cancelButtonTapped:
        return .run { _ in
          await self.dismiss()
        }
      case .deleteButtonTapped:
        return .run { [selectedCategories = state.selectedCategories] _ in
          for category in selectedCategories {
            try await swiftDataClient.deleteCategory(category)
          }
          await self.dismiss()
        }
      case let .toggleCategorySelection(category):
        state.selectedCategories.toggle(category)
        return .none
      case .categoryGrid(.toggleCategorySelection(_)):
        return .none
      }
    }
  }
}
