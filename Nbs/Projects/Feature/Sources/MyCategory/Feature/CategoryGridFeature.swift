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
        return .run { send in
          await send(.fetchCategoriesResponse(Result {
            try swiftDataClient.fetchCategories()
          }))
        }
      case let .fetchCategoriesResponse(.success(categories)):
        let allCategory = CategoryItem(categoryName: "전체", icon: .init(number: 16))
        state.categories = [allCategory] + categories
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
