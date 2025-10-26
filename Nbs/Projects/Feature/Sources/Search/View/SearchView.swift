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
  let store: StoreOf<SearchFeature>
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
        
        ScrollView(.vertical, showsIndicators: false) {
          VStack(alignment: .leading) {
            if store.topAppBar.searchText.isEmpty {
              let recentSearchesExist = !store.recentSearch.searches.isEmpty
              let recentLinksExist = !store.recentLink.recentLinkItem.isEmpty
              
              if !recentSearchesExist && !recentLinksExist {
                EmptySearchView(type: .emptyRecentSearch)
              } else {
                if recentSearchesExist {
                  RecentSearchListView(store: store.scope(state: \.recentSearch, action: \.recentSearch))
                }
                
                if recentSearchesExist && recentLinksExist {
                  Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.divider1)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                }
                
                if recentLinksExist {
                  RecentLinkListView(store: store.scope(state: \.recentLink, action: \.recentLink))
                }
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
