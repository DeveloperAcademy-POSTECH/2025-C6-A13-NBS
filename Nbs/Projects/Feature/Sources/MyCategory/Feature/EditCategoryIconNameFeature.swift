
//
//  EditCategoryIconNameFeature.swift
//  Feature
//
//  Created by 홍 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture
import Domain
import DesignSystem

@Reducer
struct EditCategoryIconNameFeature {
  
  @Dependency(\.linkNavigator) var linkNavigator
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State: Equatable {
    var topAppBar = TopAppBarDefaultRightIconxFeature.State(title: "카테고리 수정하기")
    var categoryName: String
    var category: CategoryItem?
    var selectedIcon: CategoryIcon?
    var isDuplicate: Bool = false
    var textFieldStyle: JNTextFieldStyle = .default
    
    init(category: CategoryItem?) {
      self.category = category
      self.categoryName = category?.categoryName ?? ""
      self.selectedIcon = category?.icon ?? .init(number: 1)
    }
  }
  
  enum Action {
    case compeleteButtonTapped
    case topAppBar(TopAppBarDefaultRightIconxFeature.Action)
    case setCategoryName(String)
    case selectIcon(CategoryIcon?)
    case _setDuplicate(Bool)
    case setTextFieldStyle(JNTextFieldStyle)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.topAppBar, action: \.topAppBar) {
      TopAppBarDefaultRightIconxFeature()
    }
    
    Reduce { state, action in
      switch action {
      case let .setCategoryName(name):
        state.categoryName = name
        state.isDuplicate = false
        state.textFieldStyle = .default
        return .none
      case let .selectIcon(icon):
        state.selectedIcon = icon
        return .none
      case .compeleteButtonTapped:
        return .run { [category = state.category, name = state.categoryName] send in
          let categories = try swiftDataClient.fetchCategories()
          let isDuplicate = categories.contains { $0.categoryName.lowercased() == name.lowercased() && $0.id != category?.id }
          
          await send(._setDuplicate(isDuplicate))
        }
        
      case let ._setDuplicate(isDuplicate):
        state.isDuplicate = isDuplicate
        state.textFieldStyle = isDuplicate ? .errorCaption : .default
        
        if !isDuplicate {
          return .run { [id = state.category?.id, name = state.categoryName, icon = state.selectedIcon] _ in
            guard let id, let icon else { return }
            await MainActor.run {
              do {
                try swiftDataClient.updateCategoryItem(id, name, icon)
              } catch {
                print("카테고리 업데이트 실패 \(error)")
              }
            }
            await linkNavigator.pop()
          }
        } else {
          return .none
        }
        
        case let .setTextFieldStyle(style):
          state.textFieldStyle = style
          return .none
          
      case .topAppBar(.tapBackButton):
        return .run { _ in await linkNavigator.pop() }
      }
    }
  }
}

