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
    var selectedCategory: CategoryItem?
  }
  enum Action {
    case onAppear
    case fetchCategoriesResponse(TaskResult<[CategoryItem]>)
    case selectCategory(CategoryItem)
    case delegate(Delegate)

    enum Delegate: Equatable {
      case categorySelected(CategoryItem)
    }
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(.fetchCategoriesResponse(TaskResult {
            try swiftDataClient.fetchCategories()
          }))
        }
      case let .fetchCategoriesResponse(.success(categories)):
        state.categories = categories
        return .none
      case let .selectCategory(category):
        state.selectedCategory = category
        return .send(.delegate(.categorySelected(category)))

      case .fetchCategoriesResponse(.failure(_)):
        return .none
      case .delegate(_):
        return .none
      }
    }
  }
}
