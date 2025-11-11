//
//  CategoryChipFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct CategoryChipFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State: Equatable {
    /// 선택 가능한 카테고리 목록
    var categories: [CategoryItem] = []
    
    /// 현재 선택된 카테고리
    var selectedCategory: CategoryItem? = nil
  }
  
  enum Action {
    case onAppear
    case categoriesResponse(Result<[CategoryItem], Error>)
    case categoryTapped(CategoryItem)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        /// 카테고리 불러오기
        return .run { send in
          await send(.categoriesResponse(Result {
            try swiftDataClient.fetchCategories()
          }))
        }
        
      case let .categoriesResponse(.success(items)):
        /// 카테고리를 가상의 첫 항목으로 추가
        let allCategory = CategoryItem(categoryName: "전체", icon: .init(number: 0))
        let reversed = items.reversed()
        
        state.categories = [allCategory] + reversed
        
        if let selected = state.selectedCategory,
           let match = state.categories.first(where: { $0.categoryName == selected.categoryName }) {
          state.selectedCategory = match
        } else {
          state.selectedCategory = allCategory
        }
        return .none
        
      case let .categoriesResponse(.failure(error)):
        print("Category fetch failed:", error)
        return .none
        
      case let .categoryTapped(category):
        state.selectedCategory = category
        return .none
      }
    }
  }
}

