//
//  SelectBottomSheetFeature.swift
//  Feature
//
//  Created by 여성일 on 10/22/25.
//

import ComposableArchitecture
import DesignSystem
import Domain
import Foundation

@Reducer
struct SelectBottomSheetFeature {
  @ObservableState
  struct State: Equatable {
    var categories: IdentifiedArrayOf<CategoryProps> = []
    var selectedCategory: String?
    
    init(categories: IdentifiedArrayOf<CategoryProps> = [], selectedCategory: String? = nil) {
      self.categories = categories
      self.selectedCategory = selectedCategory
    }
  }
  
  enum Action: Equatable {
    case categoryTapped(String)
    case selectButtonTapped
    case closeTapped
    
    case delegate(DelegateAction)
  }
  
  enum DelegateAction: Equatable {
    case categorySelected(String?)
    case dismiss
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.swiftDataClient) var swiftDataClient

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {        
      case .categoryTapped(let category):
        print(category)
        state.selectedCategory = category
        return .none
        
      case .closeTapped:
        return .run { _ in await self.dismiss() }
        
      case .selectButtonTapped:
        return .run { [selectedCategory = state.selectedCategory] send in
          await send(.delegate(.categorySelected(selectedCategory)))
          await self.dismiss()
        }
        
      case .delegate:
        return .none
      }
    }
  }
}
