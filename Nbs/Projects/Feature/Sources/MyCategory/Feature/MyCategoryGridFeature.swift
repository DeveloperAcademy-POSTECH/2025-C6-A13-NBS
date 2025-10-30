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
  struct State: Equatable {
    var categories: [CategoryItem] = []
//    var selectedCategories: Set<CategoryItem> = []
//    var allowsMultipleSelection: Bool = false
  }
  
  enum Action {
    case onAppear
    case fetchCategoriesResponse(Result<[CategoryItem], Error>)
//    case toggleCategorySelection(CategoryItem)
//    case delegate(Delegate)
    case categoryTapped
//
//    enum Delegate: Equatable {
//      case toggleCategorySelection(CategoryItem)
//    }
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var navigation
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .categoryTapped:
        navigation.push(.linkList, nil)
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
//      case let .toggleCategorySelection(category):
//        if state.allowsMultipleSelection {
//          state.selectedCategories.toggle(category)
//        } else {
//          if state.selectedCategories.contains(category) {
//            state.selectedCategories.remove(category)
//          } else {
//            state.selectedCategories = [category]
//          }
//        }
//        return .send(.delegate(.toggleCategorySelection(category)))

      case .fetchCategoriesResponse(.failure(_)):
        return .none
      }
    }
  }
}
