//
//  SearchSuggestionView.swift
//  Feature
//
//  Created by 여성일 on 10/21/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

// MARK: - Properties
struct SearchSuggestionView: View {
  let store: StoreOf<SearchSuggestionFeature>
}

// MARK: - View
extension SearchSuggestionView {
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 12) {
        ForEach(store.suggestionItem) { result in
          Button {
            store.send(.suggestionTapped(result))
          } label: {
            highlightQuery(text: result.title, keyword: store.searchText)
              .font(.B1_M)
              .foregroundStyle(.caption1)
              .lineLimit(1)
          }
          .buttonStyle(.plain)
          .frame(height: 32)
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, 12)
  }
}

private extension SearchSuggestionView {
  func highlightQuery(text: String, keyword: String) -> Text {
    guard !keyword.isEmpty else {
      return Text(text)
    }
    
    var resultText = Text("")
    var currentIndex = text.startIndex
    
    while let range = text.range(of: keyword, options: .caseInsensitive, range: currentIndex..<text.endIndex) {
      let before = currentIndex..<range.lowerBound
      resultText = resultText + Text(text[before])
      
      let highlighted = String(text[range])
      resultText = resultText + Text(highlighted).foregroundStyle(.bl7).fontWeight(.semibold)
      
      currentIndex = range.upperBound
    }
    
    let afterRange = currentIndex..<text.endIndex
    resultText = resultText + Text(text[afterRange])
    
    return resultText
  }
}

#Preview {
  SearchSuggestionView(store: Store(initialState: SearchSuggestionFeature.State(), reducer: {
    SearchSuggestionFeature()
  }))
}
