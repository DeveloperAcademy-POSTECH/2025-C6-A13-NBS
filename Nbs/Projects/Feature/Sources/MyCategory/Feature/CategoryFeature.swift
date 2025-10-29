//
//  CategoryFeature.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct CategoryListFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable {
    var categories: [CategoryItem] = []
    var selectedCategory: CategoryItem?
    var isShowingEmptyView: Bool = false
    var addLinkView: Bool = false
  }
  
  enum Action {
    case onAppear
    case categoriesResponse(Result<[CategoryItem], Error>)
    case moreCategoryButtonTapped
    case categoryTapped(CategoryItem)
    case addCategoryButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run {
          send in await send(.categoriesResponse(Result{ try swiftDataClient.fetchCategories() }))
        }
      case let .categoriesResponse(.success(categories)):
        state.categories = categories
        state.selectedCategory = categories.first
        return .none
      case .categoriesResponse(.failure):
        return .none
      case .moreCategoryButtonTapped:
        linkNavigator.push(.myCategory, nil)
        return .none
      case let .categoryTapped(category):
        state.selectedCategory = category
        return .none
      case .addCategoryButtonTapped:
        linkNavigator.push(.addCategory, nil)
        return .none
      }
    }
  }
}
