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
  @Bindable var store: StoreOf<SearchResultFeature>
}

// MARK: - View
extension SearchResultView {
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        Text("'\(store.query.truncatedString(count: 7))' 관련 결과 \(store.filteredSearchResult.count)개")
          .font(.B2_M)
          .foregroundStyle(.caption2)
          .lineLimit(1)
          .padding(.vertical, 6)
        
        Spacer()
        
        if !store.searchResult.isEmpty {
          Button {
            store.send(.categoryButtonTapped)
          } label: {
            HStack(spacing: 6) {
              Text(store.selectedCategoryTitle)
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
          .buttonStyle(.plain)
        }
      }
      
      if !store.searchResult.isEmpty {
        ScrollView(.vertical, showsIndicators: false) {
          LazyVStack {
            ForEach(store.filteredSearchResult) { result in
              Button {
                store.send(.linkCardTapped(result))
              } label: {
                LinkCard(
                  title: result.title,
                  newsCompany: "조선 비즈",
                  image: "plus",
                  date: result.createAt.formattedKoreanDate()
                )
              }
              .buttonStyle(.plain)
            }
          }
        }
      } else {
        EmptySearchView(type: .emptyResult(searchTerm: store.query))
      }
    }
    .padding(.horizontal, 20)
    .background(Color.clear)
    .sheet(item: $store.scope(state: \.selectBottomSheet, action: \.selectBottomSheet)) { store in
      TCASelectBottomSheet(title: "카테고리 선택", store: store)
        .presentationDetents([.medium])
        .presentationCornerRadius(16)
    }
  }
}

#Preview {
  SearchResultView(
    store: Store(initialState: SearchResultFeature.State(), reducer: {
      SearchResultFeature()
    })
  )
}
