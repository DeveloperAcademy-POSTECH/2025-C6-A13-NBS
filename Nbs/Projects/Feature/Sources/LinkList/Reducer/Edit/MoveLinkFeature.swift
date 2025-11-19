//
//  MoveLinkFeature.swift
//  Feature
//
//  Created by 이안 on 10/22/25.
//

import SwiftUI

import ComposableArchitecture
import LinkNavigator
import Domain
import DesignSystem

@Reducer
struct MoveLinkFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.uuid) var uuid
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State: Equatable {
    var allLinks: [ArticleItem] = []
    var categoryName: String = "전체"
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
    case backButtonTapped
    case confirmMoveTapped
    case openCategorySheet
    case fetchCategories
    case fetchCategoriesResponse([CategoryItem])
    case selectBottomSheet(PresentationAction<SelectBottomSheetFeature.Action>)
    case moveDone(count: Int)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce {
      state,
      action in
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
        
      case .backButtonTapped:
        return .run { _ in
          await linkNavigator.pop()
        }
        
        /// 이동 버튼
      case .confirmMoveTapped:
        let selected = state.allLinks.filter { state.selectedLinks.contains($0.id) }
        guard !selected.isEmpty else { return .none }
        if state.categories.isEmpty {
          return .send(.fetchCategories)
        } else {
          return .send(.openCategorySheet)
        }
        
        /// 카테고리 로드
      case .fetchCategories:
        return .run { send in
          let items = try swiftDataClient.fetchCategories()
          await send(.fetchCategoriesResponse(items))
        }
        
      case let .fetchCategoriesResponse(items):
        state.categories = items
        return .send(.openCategorySheet)
        
        /// 시트 오픈
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
        guard let name,
              let target = state.categories.first(where: { $0.categoryName == name })
        else {
          state.selectBottomSheet = nil
          return .none
        }
        
        state.targetCategory = target
        let selected = state.allLinks.filter { state.selectedLinks.contains($0.id) }
        let moveCount = selected.count
        
        return .run { send in
          do {
            try swiftDataClient.moveLinks(selected, target)
          } catch {
            print("❌ moveLinks failed:", error)
          }
          await send(.moveDone(count: moveCount))
        }
        
      case let .moveDone(count):
        let moveCategoryName = state.targetCategory?.categoryName ?? "전체"
        return .run { _ in
          try? await Task
            .sleep(
              nanoseconds: 500_000_000
            )
          NotificationCenter.default
            .post(
              name: .linkMoved,
              object: [
                "movedCount": count,
                "categoryName": moveCategoryName
              ]
            )
          await linkNavigator.pop()
        }
        
        /// 시트에서 닫기
      case .selectBottomSheet(.presented(.delegate(.dismiss))):
        state.selectBottomSheet = nil
        return .none
        
      case .selectBottomSheet, .binding:
        return .none
      }
    }
    .ifLet(\.$selectBottomSheet, action: \.selectBottomSheet) {
      SelectBottomSheetFeature()
    }
  }
}

extension Notification.Name {
  static let linkMoved = Notification.Name("linkMoved")
}
