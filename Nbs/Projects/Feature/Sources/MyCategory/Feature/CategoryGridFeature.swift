//
//  CategoryGridFeature.swift
//  Feature
//
//  Created by 홍 on 10/19/25.
//

import ComposableArchitecture

import Domain

@Reducer
struct CategoryGridFeature {
  struct State: Equatable {
    var categories: [CategoryItem] = []
    var selectedCategories: Set<CategoryItem> = []
    var allowsMultipleSelection: Bool = false
    var showAllCategory: Bool = false
  }
  
  enum Action {
    case onAppear
    case fetchCategoriesResponse(Result<[CategoryItem], Error>)
    case toggleCategorySelection(CategoryItem)
    case delegate(Delegate)

    enum Delegate: Equatable {
      case toggleCategorySelection(CategoryItem)
    }
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.selectedCategories = []
        return .run { send in
          await send(.fetchCategoriesResponse(Result {
            try swiftDataClient.fetchCategories()
          }))
        }
      case let .fetchCategoriesResponse(.success(categories)):
        var allCategories = categories
        if state.showAllCategory {
          allCategories.append(CategoryItem(categoryName: "전체", icon: .init(number: 16)))
          state.categories = allCategories
        } else {
          state.categories = categories
        }
        return .none
      case let .toggleCategorySelection(category):
        if state.allowsMultipleSelection {
          state.selectedCategories.toggle(category)
        } else {
          if state.selectedCategories.contains(category) {
            state.selectedCategories.remove(category)
          } else {
            state.selectedCategories = [category]
          }
        }
        return .send(.delegate(.toggleCategorySelection(category)))

      case .fetchCategoriesResponse(.failure(_)):
        return .none
      case .delegate(_):
        return .none
      }
    }
  }
}
