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
  let saveAction: (CategoryItem?) -> Void
}

// MARK: - View
extension ShareBottomSheetView {
  var body: some View {
    NavigationStack {
      ZStack(alignment: .topLeading) {
        VStack(alignment: .center, spacing: 0) {
          Separator()
          HeaderView
          Spacer()
          CategoryListView
            .frame(height: 109)
          Spacer()
          MainButton("저장") {
            saveAction(selectedCategory)
          }
          .padding(.bottom, 16)
        }
        .padding(.top, 8)
      }
    }
    .frame(minHeight: 308)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
  
  private var HeaderView: some View {
    HStack {
      Text("카테고리 선택해주세요")
        .font(.B1_SB)
        .foregroundStyle(.text1)
      Spacer()
      HStack {
        NavigationLink {
          ShareInputTitleView()
        } label: {
          HStack(spacing: 4) {
            Image(icon: Icon.plus)
              .renderingMode(.template)
              .resizable()
              .frame(width: 15, height: 15)
              .foregroundStyle(.bl6)
              .padding(.leading, 10)
            
            Text("새 카테고리")
              .font(.B2_SB)
              .foregroundStyle(.bl6)
              .padding(.trailing, 16)
          }
          .frame(width: 113)
          .padding(.vertical, 6)
          .background(.bl1)
          .clipShape(.capsule)
        }
      }
    }
    .padding(.top, 16)
    .padding(.horizontal, 20)
  }
  
  private var CategoryListView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 16) {
        CategoryButton(
          title: "전체",
          icon: "primaryCategoryIcon16",
          isOn: Binding(
            get: { self.selectedCategory == nil},
            set: { isOn in
              if isOn {
                self.selectedCategory = nil
              }
            })
        )
        ForEach(categories) { category in
          CategoryButton(
            title: category.categoryName,
            icon: category.icon.name,
            isOn: Binding(
              get: { self.selectedCategory == category },
              set: { isOn in
                if isOn {
                  self.selectedCategory = category
                }
              }
            )
          )
        }
      }
      .padding(.horizontal, 20)
    }
  }
}
