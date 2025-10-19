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
  }
  enum Action {
    case onAppear
    case fetchCategoriesResponse(TaskResult<[CategoryItem]>)
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
      case .fetchCategoriesResponse(.failure):
        // Handle error if needed
        return .none
      }
    }
  }
}
