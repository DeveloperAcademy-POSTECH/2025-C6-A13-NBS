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
    case delegate(Delegate)
    case addCategoryButtonTapped
    
    enum Delegate {
      case goToMoreLinkButtonView
      case goToAddCategoryView
    }
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
        linkNavigator.push("myCategory")
        return .none
//        return .send(.delegate(.goToMoreLinkButtonView))
      case let .categoryTapped(category):
        state.selectedCategory = category
        return .none
      case .delegate:
        return .none
      case .addCategoryButtonTapped:
        return .send(.delegate(.goToAddCategoryView))
      }
    }
  }
}
