//
//  MoveLinkFeature.swift
//  Feature
//
//  Created by 이안 on 10/22/25.
//

import SwiftUI

import ComposableArchitecture
import Domain
import DesignSystem

@Reducer
struct MoveLinkFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.uuid) var uuid
  
  @ObservableState
  struct State: Equatable {
    var allLinks: [ArticleItem] = []
    var selectedLinks: Set<String> = []
    var isSelectAll: Bool = false
    var categories: [CategoryItem] = []
    var targetCategory: CategoryItem? = nil
    
    @Presents var selectBottomSheet: SelectBottomSheetFeature.State?
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case onAppear
    case toggleSelect(ArticleItem)
    case cancelTapped
    case confirmMoveTapped
    case openCategorySheet
    case fetchCategories
    case fetchCategoriesResponse([CategoryItem])
    case selectBottomSheet(PresentationAction<SelectBottomSheetFeature.Action>)
    
    case delegate(Delegate)
    enum Delegate {
      case dismiss
      case confirmMove(selected: [ArticleItem], target: CategoryItem?)
    }
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
        
        /// 전체 선택 or 해제
      case .binding(\.isSelectAll):
        if state.isSelectAll {
          state.selectedLinks = Set(state.allLinks.map(\.id))
        } else {
          state.selectedLinks.removeAll()
        }
        return .none
        
        /// 개별 토글 시 전체선택 여부 갱신
      case let .toggleSelect(link):
        if state.selectedLinks.contains(link.id) {
          state.selectedLinks.remove(link.id)
        } else {
          state.selectedLinks.insert(link.id)
        }
        state.isSelectAll = state.selectedLinks.count == state.allLinks.count
        return .none
        
      case .cancelTapped:
        return .send(.delegate(.dismiss))
        
      case .confirmMoveTapped:
        let selected = state.allLinks.filter { state.selectedLinks.contains($0.id) }
        guard !selected.isEmpty else { return .none }
        if state.categories.isEmpty {
          return .send(.fetchCategories)
        } else {
          return .send(.openCategorySheet)
        }
        
      case .fetchCategories:
        return .run { send in
          let items = try swiftDataClient.fetchCategories()
          await send(.fetchCategoriesResponse(items))
        }
        
      case let .fetchCategoriesResponse(items):
        state.categories = items
        return .send(.openCategorySheet)
        
        // 시트 오픈
      case .openCategorySheet:
        var props: [CategoryProps] = [CategoryProps(id: uuid(), title: "전체")]
        props.append(contentsOf: state.categories.map { CategoryProps(id: uuid(), title: $0.categoryName) })
        state.selectBottomSheet = .init(
          categories: .init(uniqueElements: props),
          selectedCategory: nil
        )
        return .none
        
        /// 시트에서 "선택하기"
      case .selectBottomSheet(.presented(.delegate(.categorySelected(let name)))):
        let target = state.categories.first(where: { $0.categoryName == (name ?? "") })
        state.targetCategory = target
        let selected = state.allLinks.filter { state.selectedLinks.contains($0.id) }
        state.selectBottomSheet = nil
        return .send(.delegate(.confirmMove(selected: selected, target: target)))
        
        /// 시트에서 닫기
      case .selectBottomSheet(.presented(.delegate(.dismiss))):
        state.selectBottomSheet = nil
        return .none
        
      case .binding, .selectBottomSheet, .delegate:
        return .none
      }
    }
    .ifLet(\.$selectBottomSheet, action: \.selectBottomSheet) { SelectBottomSheetFeature()
    }
  }
}
