//
//  CategoryChipList.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import SwiftUI
import ComposableArchitecture
import Domain
import DesignSystem

/// 링크 리스트의 상단 칩 리스트
struct CategoryChipList {
  @Bindable var store: StoreOf<CategoryChipFeature>
  var onTap: (() -> Void)? = nil
}

// MARK: - Body
extension CategoryChipList: View {
  var body: some View {
    HStack(spacing: 8) {
      categoryChipList
      bottomSheetButton
    }
    .padding(.horizontal, 20)
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  /// 카테고리 칩버튼 리스트
  private var categoryChipList: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 6) {
          ForEach(store.categories, id: \.categoryName) { category in
            let isOn = store.selectedCategory?.categoryName == category.categoryName
            ChipButton(
              title: category.categoryName,
              style: .soft,
              isOn: .constant(store.selectedCategory == category)
            ) {
              store.send(.categoryTapped(category))
              withAnimation(.easeInOut(duration: 0.2)) {
                proxy.scrollTo(category, anchor: .center)
              }
            }
            .id(category.categoryName)
          }
        }
        .frame(minHeight: 36)
      }
    }
  }
  
  /// 바텀시트 버튼
  private var bottomSheetButton: some View {
    Button {
      onTap?()
    } label: {
      ZStack {
        Rectangle()
          .fill(.clear) // 이후 그라데이션 넣을 예정
          .frame(width: 32, height: 32)
        
        Image(icon: Icon.smallChevronDown)
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)
          .foregroundStyle(.iconDisabled)
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  CategoryChipList(
    store: Store(initialState: CategoryChipFeature.State()) {
      CategoryChipFeature()
    }
  )
}
