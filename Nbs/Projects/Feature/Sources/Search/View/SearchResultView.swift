//
//  SearchResultView.swift
//  Feature
//
//  Created by 여성일 on 10/20/25.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

// MARK: - Properties
struct SearchResultView: View {
  let store: StoreOf<SearchResultFeature>
  
  private var truncatedQuery: String {
    let query = store.query
    if query.count > 10 {
      return String(query.prefix(10)) + "..."
    } else {
      return query
    }
  }
}

// MARK: - View
extension SearchResultView {
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        Text("'\(truncatedQuery)' 관련 결과 \(store.searchResult.count)개")
          .font(.B2_M)
          .foregroundStyle(.caption2)
          .lineLimit(1)
          .padding(.vertical, 6)

        Spacer()
        
        if !store.searchResult.isEmpty {
          Button {
            
          } label: {
            HStack(spacing: 6) {
              Text("카테고리")
                .padding(.leading, 18)
                .foregroundStyle(.caption1)
                .font(.B2_M)
              Image(icon: Icon.smallChevronDown)
                .frame(width: 20, height: 20)
                .padding(.trailing, 12)
            }
            .padding(.vertical, 6)
            .clipShape(.capsule)
            .overlay {
              RoundedRectangle(cornerRadius: 1000)
                .stroke(.divider1, lineWidth: 1)
            }
          }
        }
      }
      
      if !store.searchResult.isEmpty {
        ScrollView(.vertical, showsIndicators: false) {
          LazyVStack {
            ForEach(store.searchResult) { result in
              Button {
                store.send(.linkCardTapped(result))
              } label: {
                LinkCard(
                  title: result.title,
                  newsCompany: "조선 비즈",
                  image: "plus",
                  date: "2025년 10월 7일"
                )
              }
              .buttonStyle(.plain)
            }
          }
        }
      } else {
        EmptySearchView()
      }
    }
    .padding(.horizontal, 20)
    .background(Color.clear)
  }
}

#Preview {
  SearchResultView(
    store: Store(initialState: SearchResultFeature.State(), reducer: {
      SearchResultFeature()
    })
  )
}
