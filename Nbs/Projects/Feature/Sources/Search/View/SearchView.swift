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
  @Query private var linkItem: [LinkItem]
  @Query private var categoryItem: [CategoryItem]
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
        RecentSearchListView(
          store: store.scope(state: \.recentSearch, action: \.recentSearch)
        )
        Rectangle()
          .frame(maxWidth: .infinity)
          .frame(height: 1)
          .padding(.vertical, 12)
          .padding(.horizontal, 20)
          .foregroundStyle(.divider1)

        RecentLinkListView()

//        if !store.recentSearch.searches.isEmpty || !store.recentSearch.links.isEmpty {
//            if !store.recentSearchReducerState.searches.isEmpty {
//              RecentSearchListView(
//                store: store.scope(
//                  state: \.recentSearchReducerState,
//                  action: \.recentSearchReducerAction
//                )
//              )
//            }
//            
//            if !store.recentLinkReducerState.links.isEmpty {
//              RecentLinkView(
//                store: store.scope(
//                  state: \.recentLinkReducerState,
//                  action: \.recentLinkReducerAction
//                )
//              )
//            }
//        } else {
//          EmptySearchView()
//        }
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      store.send(.backgroundTapped)
    }
    .onAppear {
      store.send(.onAppear)
      linkItem.forEach {
        print("--- LinkItem Detail ---")
        print("Title: \($0.title)")
        print("URL: \($0.urlString)")
        if let category = $0.category {
          print("Cateogry: \(category.categoryName)")
        } else {
          print("Category: none")
        }
        if !$0.highlights.isEmpty {
          $0.highlights.forEach { item in
            print("Type: \(item.type), Comments: \(item.comments)")
          }
        } else {
          print("Highlitht none")
        }
      }
    }
  }
}

#Preview {
  SearchView(store: Store(initialState: SearchFeature.State(), reducer: {
    SearchFeature()
  }))
}
