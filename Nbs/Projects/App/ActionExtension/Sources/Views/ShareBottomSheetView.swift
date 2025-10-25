//
//  ShareBottomSheetView.swift
//  Nbs
//
//  Created by 여성일 on 10/18/25.
//

import SwiftUI

import SwiftData

import DesignSystem
import Domain

// MARK: - Properties
struct ShareBottomSheetView: View {
  @Query(sort: [SortDescriptor<CategoryItem>(\.createdAt, order: .reverse)]) private var categories: [CategoryItem]
  @State private var selectedCategory: CategoryItem? = nil
  let confirmAction: (CategoryItem?) -> Void
}

// MARK: - View
extension ShareBottomSheetView {
  var body: some View {
    NavigationStack {
      ZStack(alignment: .topLeading) {
        Color.background.ignoresSafeArea()
        VStack(alignment: .center, spacing: 8) {
          Separator()
          HeaderView
          SelectCategoryView
        }
        .padding(.top, 8)
      }
    }
    .frame(minHeight: 258)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
  
  private var HeaderView: some View {
    HStack {
      HStack(spacing: 2) {
        Text("저장 완료")
          .font(.B1_SB)
          .foregroundStyle(.bl6)
      }
      Spacer()
      HStack(spacing: 8) {
        NavigationLink {
          ShareInputTitleView()
        } label: {
          Text("+ 카테고리 추가")
            .font(.B2_SB)
            .foregroundStyle(.bl6)
            .frame(width: 119, height: 36)
            .background(.bl1)
            .clipShape(.capsule)
        }
        ConfirmButton(action: { confirmAction(selectedCategory) })
      }
    }
    .padding(.vertical, 8)
    .padding(.horizontal, 20)
  }
  
  private var EmptyCategoryView: some View {
    VStack(alignment: .center, spacing: 4) {
      Text("아무 카테고리도 존재하지 않아요")
        .font(.C1)
        .foregroundStyle(.caption1)
      Text("카테고리를 추가하고\n원하는 주제별로 링크를 정리해봐요")
        .font(.C2)
        .multilineTextAlignment(.center)
        .foregroundStyle(.caption2)
    }
    .frame(height: 116)
    .frame(maxWidth: .infinity)
    .background(.n20)
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
  
  private var CategoryListView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 16) {
        ForEach(categories) { category in
          CategoryButton(
            title: category.categoryName,
            icon: category.icon.name,
            isOn: Binding(
              get: { selectedCategory == category },
              set: { isOn in
                if isOn {
                  selectedCategory = category
                } else if selectedCategory == category {
                  selectedCategory = nil
                }
              }
            )
          )
        }
      }
    }
  }
  
  private var SelectCategoryView: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("카테고리 선택하기")
        .font(.B2_SB)
        .foregroundStyle(.text1)
        .padding(.bottom, 8)
      
      if categories.isEmpty {
        EmptyCategoryView
      } else {
        CategoryListView
      }
    }
    .padding(.bottom, 32)
    .padding(.horizontal, 20)
  }
}

