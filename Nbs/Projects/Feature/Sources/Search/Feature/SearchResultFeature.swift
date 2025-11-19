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
    var searchResult: [ArticleItem] = []
    var filteredSearchResult: [ArticleItem] = []
    var query: String = ""
    var selectedCategoryTitle: String = "카테고리"
    var filteredCategories: [CategoryItem] = []
    var originalSearchResults: [ArticleItem] = []
    
    @Presents var selectBottomSheet: SelectBottomSheetFeature.State?
  }
  
  enum Action: Equatable {
    case loadSearchResult(String)
    case searchResponse([ArticleItem])
    case linkCardTapped(ArticleItem)
    case categoryButtonTapped
    
    case selectBottomSheet(PresentationAction<SelectBottomSheetFeature.Action>)
  }
  
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var linkNavigator
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
        state.selectedCategoryTitle = "카테고리"
        return .none
        
      case .linkCardTapped(let item):
        linkNavigator.push(.linkDetail, item)
        return .none
        
      case .categoryButtonTapped:
        let categoriesFromResults = state.searchResult.compactMap { $0.category }
        var uniqueCategories = Array(Set(categoriesFromResults))
        uniqueCategories.sort { $0.categoryName < $1.categoryName }
        
        var categoryProps = uniqueCategories.map { CategoryProps(id: $0.id, title: $0.categoryName) }
        
        let allCategory = CategoryProps(id: uuid(), title: "전체")
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
        
      case .selectBottomSheet:
        return .none
      }
    }
    .ifLet(\.$selectBottomSheet, action: \.selectBottomSheet) {
      SelectBottomSheetFeature()
    }
  }
}

