//
//  SearchView.swift
//  Feature
//
//  Created by 여성일 on 10/19/25.
//

import SwiftUI

import ComposableArchitecture
import Domain
import DesignSystem

import SwiftData

// MARK: - Properties
struct SearchView: View {
  @Bindable var store: StoreOf<SearchFeature>
}

// MARK: - View
extension SearchView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack(alignment: .leading) {
        TopAppBarSearchView(
          store: store.scope(state: \.topAppBar, action: \.topAppBar)
        )
        
        if store.topAppBar.searchText.isEmpty {
          if !store.recentSearch.searches.isEmpty {
            RecentSearchListView(store: store.scope(state: \.recentSearch, action: \.recentSearch))
          } else {
            EmptySearchView()
          }
        } else {
          if store.isSearchSubmitted {
            SearchResultView(
              store: store.scope(state: \.searchResult, action: \.searchResult)
            )
          } else {
            SearchSuggestionView(store: store.scope(state: \.searchSuggestion, action: \.searchSuggestion))
          }
        }
      }
      .navigationBarHidden(true)
      .contentShape(Rectangle())
      .onTapGesture {
        store.send(.backgroundTapped)
      }
      .onAppear {
        store.send(.onAppear)
      }
    }
  }
}

#Preview {
  SearchView(store: Store(initialState: SearchFeature.State(), reducer: {
    SearchFeature()
  }))
}
