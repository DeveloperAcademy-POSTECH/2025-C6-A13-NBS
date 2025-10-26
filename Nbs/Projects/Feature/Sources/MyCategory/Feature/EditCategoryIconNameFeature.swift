
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
  
  @Dependency(\.linkNavigator) var linkNavigator
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State: Equatable {
    var topAppBar = TopAppBarDefaultRightIconxFeature.State(title: "카테고리 수정하기")
    var categoryName: String
    var category: CategoryItem
    var selectedIcon: CategoryIcon?
    
    init(category: CategoryItem) {
      self.category = category
      self.categoryName = category.categoryName
      self.selectedIcon = category.icon
    }
  }
  
  enum Action {
    case compeleteButtonTapped
    case topAppBar(TopAppBarDefaultRightIconxFeature.Action)
    case setCategoryName(String)
    case selectIcon(CategoryIcon)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.topAppBar, action: \.topAppBar) {
      TopAppBarDefaultRightIconxFeature()
    }
    
    Reduce { state, action in
      switch action {
      case let .setCategoryName(name):
        state.categoryName = name
        return .none
      case let .selectIcon(icon):
        state.selectedIcon = icon
        return .none
      case .compeleteButtonTapped:
        return .run { [category = state.category, name = state.categoryName, icon = state.selectedIcon] _ in
          category.categoryName = name
          if let icon {
            category.icon = icon
          }
          try await swiftDataClient.updateCategory(category)
          linkNavigator.pop()
        }
      case .topAppBar(.tapBackButton):
        linkNavigator.pop()
        return .none
      }
    }
  }
}

