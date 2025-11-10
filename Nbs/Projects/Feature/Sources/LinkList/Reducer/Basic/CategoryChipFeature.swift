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
    case categoriesResponse(TaskResult<[CategoryItem]>)
    case categoryTapped(CategoryItem)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        /// 카테고리 불러오기
        return .run { send in
          await send(.categoriesResponse(TaskResult {
            try swiftDataClient.fetchCategories()
          }))
        }
        
      case let .categoriesResponse(.success(items)):
        /// 카테고리를 가상의 첫 항목으로 추가
        let allCategory = CategoryItem(categoryName: "전체", icon: .init(number: 0))
        let reversed = items.reversed()
        state.categories = [allCategory] + reversed
        if state.selectedCategory == nil {
          state.selectedCategory = allCategory
        } else if let selectedName = state.selectedCategory?.categoryName,
                  let match = state.categories.first(where: { $0.categoryName == selectedName }) {
          // 기존 선택 카테고리가 목록에 여전히 존재하면 그걸 유지
          state.selectedCategory = match
        } else {
          // 기존 선택 카테고리가 목록에 없을 경우만 전체로 복귀
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

