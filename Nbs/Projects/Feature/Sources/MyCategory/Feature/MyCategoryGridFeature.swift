//
//  MyCategoryGridFeature.swift
//  Feature
//
//  Created by 홍 on 10/31/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct MyCategoryGridFeature {
  @Dependency(\.linkNavigator) var linkNavigator
  
  struct State: Equatable {
    var categories: [CategoryItem] = []
  }
  
  enum Action {
    case onAppear
    case fetchCategoriesResponse(Result<[CategoryItem], Error>)
    case categoryTapped(CategoryItem)
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var navigation
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .categoryTapped(category):
        let payload = LinkListPayload(links: [], categoryName: category.categoryName)
        linkNavigator.push(.linkList, payload)
        return .none
      case .onAppear:
        return .run { send in
          await send(.fetchCategoriesResponse(Result {
            try swiftDataClient.fetchCategories()
          }))
        }
      case let .fetchCategoriesResponse(.success(categories)):
        state.categories = categories
        return .none
      case .fetchCategoriesResponse(.failure(_)):
        return .none
      }
    }
  }
}
