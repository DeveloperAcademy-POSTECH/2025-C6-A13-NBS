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
  
  @ObservableState
  struct State: Equatable {
    var naviTitle: String = "삭제할 카테고리를 입력해주세요."
    var categoryGrid = CategoryGridFeature.State()
    var selectedCategory: CategoryItem?
  }
  
  enum Action {
    case categoryGrid(CategoryGridFeature.Action)
    case cancelButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.categoryGrid, action: \.categoryGrid) {
      CategoryGridFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .categoryGrid(.delegate(.categorySelected(let category))):
        state.selectedCategory = category
        return .none
      case .categoryGrid(.onAppear):
        return .none
      case .categoryGrid(.fetchCategoriesResponse(_)):
        return .none
      case .categoryGrid(.selectCategory(_)):
        return .none
      case .cancelButtonTapped:
        return .run { _ in
          await self.dismiss()
        }
      }
    }
  }
}
