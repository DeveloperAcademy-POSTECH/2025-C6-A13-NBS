//
//  CategoryList.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

struct CategoryListView {
  let store: StoreOf<CategoryListFeature>
}

extension CategoryListView: View {
  var body: some View {
    VStack(spacing: 8) {
      HStack(spacing: 0) {
        Text(ArticleNameSpace.showCategory)
          .font(.B1_SB)
          .foregroundStyle(.caption1)
          .padding(.leading, 6)
        Spacer()
        Button {
          store.send(.moreCategoryButtonTapped)
        } label: {
          HStack(spacing: 0) {
            Text(ArticleNameSpace.showMore)
              .font(.B2_M)
              .foregroundStyle(.caption1)
            Image(icon: Icon.smallChevronRight)
              .resizable()
              .frame(width: 20, height: 20)
          }
        }
      }
      .padding(.horizontal, 20)
      
      if store.categories.isEmpty {
        Button {
          store.send(.addCategoryButtonTapped)
        } label: {
          HStack {
            VStack(spacing: 0) {
              Group {
                Text("새로운 카테고리를")
                Text("만들어보세요")
              }
                .font(.H4_SB)
                .foregroundStyle(.text1)
                .frame(maxWidth: .infinity, alignment: .leading)
              Text("원하는 주제별로 링크를 정리하세요")
                .font(.B2_M)
                .foregroundStyle(.caption1)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
            Image(uiImage: DesignSystemAsset.emptyImage.image)
              .resizable()
              .frame(width: 72, height: 72)
          }
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 20)
          .frame(height: 116)
          .background(DesignSystemAsset.bl1.swiftUIColor)
          .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 20)
      } else {
        scrollView
      }
    }
    .onAppear { store.send(.onAppear) }
  }
  
  private var scrollView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        ForEach(store.categories.reversed()) { category in
          Button {
            store.send(.categoryTapped(category))
          } label: {
            ZStack(alignment: .bottomTrailing) {
              VStack(alignment: .leading, spacing: 4) {
                Text(category.categoryName)
                  .font(.B1_SB)
                  .foregroundStyle(.text1)
                  .multilineTextAlignment(.leading)
                  .lineLimit(2)
                Text("\(category.links.count)개")
                  .font(.B2_M)
                  .foregroundStyle(.caption1)
                Spacer()
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.top, 16)
              .padding(.leading, 16)
              DesignSystemAsset.categoryIcon(number: category.icon.number)
                .resizable()
                .frame(width: 56, height: 56)
                .padding(.trailing, 12)
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity, minHeight: 116)
            .background(DesignSystemAsset.color(number: category.icon.number))
            .clipShape(RoundedRectangle(cornerRadius: 12))
          }
          .frame(width: 160, height: 116)
//          .background(store.selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
          .cornerRadius(12)
          .buttonStyle(.plain)
        }
      }
      .padding(.horizontal, 20)
    }
  }
}

#Preview {
  CategoryListView(store: Store(initialState: CategoryListFeature.State()) {
    CategoryListFeature()
  })
}
