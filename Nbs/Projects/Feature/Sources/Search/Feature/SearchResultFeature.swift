//
//  SearchResultFeature.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import ComposableArchitecture

import Foundation

import DesignSystem
import Domain

@Reducer
struct SearchResultFeature {
  @ObservableState
  struct State: Equatable {
    var searchResult: [LinkItem] = []
    var filteredSearchResult: [LinkItem] = []
    var query: String = ""
    var selectedCategoryTitle: String = "카테고리"
    
    @Presents var selectBottomSheet: SelectBottomSheetFeature.State?
  }
  
  enum Action: Equatable {
    case loadSearchResult(String)
    case searchResponse([LinkItem])
    case linkCardTapped(LinkItem)
    case categoryButtonTapped
    
    case selectBottomSheet(PresentationAction<SelectBottomSheetFeature.Action>)
    case fetchAllCategories
    case responseCategoryItems([CategoryItem])
    
    case delegate(DelegateAction)
  }
  
  enum DelegateAction: Equatable {
    case openLinkDetail(LinkItem)
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.uuid) var uuid
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .loadSearchResult(let query):
        state.query = query
        return .run { send in
          let response = try swiftDataClient.searchLinks(query)
          await send(.searchResponse(response))
        }
        
      case .searchResponse(let item):
        state.searchResult = item
        state.filteredSearchResult = item
        return .none
        
      case .linkCardTapped(let item):
        return .send(.delegate(.openLinkDetail(item)))
        
      case .categoryButtonTapped:
        return .send(.fetchAllCategories)
        
      case .fetchAllCategories:
        return .run { send in
          let categoryItems = try swiftDataClient.fetchCategories()
          await send(.responseCategoryItems(categoryItems))
        }
        
      case .responseCategoryItems(let items):
        let allCategory = CategoryProps(id: uuid(), title: "전체")
        var categoryProps: [CategoryProps] = items.map { item in
          CategoryProps(id: uuid(), title: item.categoryName)
        }
        categoryProps.insert(allCategory, at: 0)
        let allCategories = IdentifiedArray(uniqueElements: categoryProps)
        
        state.selectBottomSheet = SelectBottomSheetFeature.State(
          categories: allCategories,
          selectedCategory: state.selectedCategoryTitle == "카테고리" ? "전체" : state.selectedCategoryTitle
        )
        return .none
        
      case .selectBottomSheet(.presented(.delegate(.categorySelected(let category)))):
        if let category = category {
          var selectedCategoryTitle: String {
            category == "전체" ? "카테고리" : category
          }
          state.selectedCategoryTitle = selectedCategoryTitle
          
          if category == "전체" {
            state.filteredSearchResult = state.searchResult
          } else {
            state.filteredSearchResult = state.searchResult.filter { link in
              link.category?.categoryName == category
            }
          }
        }
        return .none
        
      case .delegate, .selectBottomSheet:
        return .none
      }
    }
    .ifLet(\.$selectBottomSheet, action: \.selectBottomSheet) {
      SelectBottomSheetFeature()
    }
  }
}

