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

// MARK: - View
extension CategoryChipList: View {
  var body: some View {
    ZStack {
      Color.background
        .ignoresSafeArea()
      ZStack(alignment: .trailing) {
        categoryChipList
//          .padding(.horizontal, 20)
        bottomSheetButton
      }
      .task { store.send(.onAppear) }
    }
  }
  
  /// 카테고리 칩버튼 리스트
  private var categoryChipList: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 6) {
          Color.clear
            .frame(width: 14)
          ForEach(store.categories, id: \.categoryName) { category in
            let isOn = store.selectedCategory?.categoryName == category.categoryName
            ChipButton(
              title: category.categoryName,
              style: .soft,
              isOn: .constant(isOn)
            ) {
              store.send(.categoryTapped(category))
              withAnimation(.easeInOut(duration: 0.2)) {
                proxy.scrollTo(category.categoryName, anchor: .center)
              }
            }
            .id(category.categoryName)
          }
          Color.clear
            .frame(width: 56)
            .id("endPadding")
        }
        .frame(minHeight: 36)
      }
      .onChange(of: store.selectedCategory?.categoryName) { _, newValue in
        guard let newValue else { return }
        withAnimation(.easeInOut(duration: 0.25)) {
          proxy.scrollTo(newValue, anchor: .center)
          
          if newValue == store.categories.last?.categoryName {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
              withAnimation(.easeInOut(duration: 0.25)) {
                proxy.scrollTo("endPadding", anchor: .trailing)
              }
            }
          }
        }
      }
      .onChange(of: store.categories.map(\.categoryName)) { _, _ in
        // 카테고리 목록이 비어있지 않고, 선택된 카테고리가 있으면 그걸로 스크롤
        guard
          !store.categories.isEmpty,
          let name = store.selectedCategory?.categoryName
        else { return }
        
        DispatchQueue.main.async {
          withAnimation(.easeInOut(duration: 0.25)) {
            proxy.scrollTo(name, anchor: .center)
          }
        }
      }
    }
  }
  
  /// 바텀시트 버튼
  private var bottomSheetButton: some View {
    ZStack(alignment: .trailing) {
      HStack(spacing: .zero) {
        Rectangle()
          .fill(
            LinearGradient(
              stops: [
                Gradient.Stop(color: .bgButtonGrad1, location: 0.00),
                Gradient.Stop(color: .bgButtonGrad2, location: 0.16),
                Gradient.Stop(color: .bgButtonGrad3, location: 0.73),
                Gradient.Stop(color: .bgButtonGrad4, location: 1.00)
              ],
              startPoint: UnitPoint(x: 1, y: 0.5),
              endPoint: UnitPoint(x: 0, y: 0.5)
            )
          )
          .frame(width: 28, height: 36)
        
        Rectangle()
          .fill(Color.background)
          .frame(width: 44, height: 36)
      }
      
      Button {
        onTap?()
      } label: {
        Image(icon: Icon.smallChevronDown)
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)
          .foregroundStyle(.iconDisabled)
      }
      .buttonStyle(.plain)
      .padding(.trailing, 18)
    }
  }
}

#Preview {
  CategoryChipList(
    store: Store(initialState: CategoryChipFeature.State()) {
      CategoryChipFeature()
    }
  )
}
