//
//  SearchSuggestionView.swift
//  Feature
//
//  Created by 여성일 on 10/21/25.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Properties
struct SearchSuggestionView: View {
  let store: StoreOf<SearchSuggestionFeature>
}

extension SearchSuggestionView {
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 16) {
        ForEach(store.suggestionItem) { result in
          Button {
            
          } label: {
            Text(result.title)
              .font(.B1_M)
              .foregroundStyle(.caption1)
              .lineLimit(1)
          }
          .buttonStyle(.plain)
        }
      }
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  SearchSuggestionView(store: Store(initialState: SearchSuggestionFeature.State(), reducer: {
    SearchSuggestionFeature()
  }))
}
