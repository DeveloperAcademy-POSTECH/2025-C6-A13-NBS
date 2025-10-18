//
//  CategoryChipFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import ComposableArchitecture

@Reducer
struct CategoryChipFeature {
  @ObservableState
  struct State: Equatable {
    /// 선택 가능한 카테고리 목록
    var categories: [String] = [
      "전체", "시사 스터디", "경제", "금융", "기술", "디자인", "안녕", "나는", "집에", "가고", "싶어"
    ]
    
    /// 현재 선택된 카테고리
    var selectedCategory: String = "전체"
  }
  
  enum Action {
    case categoryTapped(String)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .categoryTapped(category):
        state.selectedCategory = category
        return .none
      }
    }
  }
}

