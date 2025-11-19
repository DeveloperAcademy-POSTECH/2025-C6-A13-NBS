//
//  MoveLinkView.swift
//  Feature
//
//  Created by 이안 on 10/22/25.
//

import SwiftUI

import ComposableArchitecture
import Domain
import DesignSystem

struct MoveLinkView: View {
  @Bindable var store: StoreOf<MoveLinkFeature>
  @State private var showScrollToTopButton = false
}

extension MoveLinkView {
  var body: some View {
    ZStack {
      Color.background
        .ignoresSafeArea()
      ScrollViewReader { proxy in
        ZStack(alignment: .bottomTrailing) {
          VStack(alignment: .leading, spacing: 0) {
            topContents
            middleContents
            bottomContents
          }
          
          ScrollFloatingButton(
            isVisible: $showScrollToTopButton,
            proxy: proxy,
            targetID: "moveTop"
          )
          .zIndex(1)
          .padding(.bottom, 72)
        }
        .onPreferenceChange(MoveScrollOffsetKey.self) { offsetY in
          withAnimation(.easeInOut(duration: 0.2)) {
//            showScrollToTopButton = offsetY < -50
            showScrollToTopButton = true
          }
        }
        .sheet(item: $store.scope(state: \.selectBottomSheet, action: \.selectBottomSheet)
        ) { selectStore in
          TCASelectBottomSheet(
            title: "카테고리 이동",
            buttonTitle: "이동하기",
            store: selectStore
          )
          .presentationDetents([.medium])
          .presentationCornerRadius(16)
        }
      }
    }
  }
  
  /// 링크 이동하기 네비게이션바
  private var topContents: some View {
    TopAppBarDefaultRightIconx(title: "링크 이동하기") {
      store.send(.backButtonTapped)
    }
  }
  
  private var middleContents: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 0) {
        Color.clear
          .frame(height: 0)
          .id("moveTop")
        
        linkSelectView
        articleListView
        
        GeometryReader { geo in
          Color.clear
            .preference(
              key: MoveScrollOffsetKey.self,
              value: geo.frame(in: .named("scroll")).minY
            )
        }
        .frame(height: 0)
      }
    }
    .coordinateSpace(name: "scroll")
  }
  
  /// 링크 개수 + 선택
  private var linkSelectView: some View {
    HStack(spacing: 10) {
      Text("\(store.categoryName) (\(store.allLinks.count)개)")
        .font(.B2_M)
        .foregroundStyle(.caption3)
      
      Spacer()
      
      Text("모두 선택")
        .font(.B2_SB)
        .foregroundStyle(.caption1)
      
      CheckboxButton(
        isOn: $store.isSelectAll,
        style: .clear,
        size: .small
      )
    }
    .padding(EdgeInsets(top: 8, leading: 24, bottom: 12, trailing: 24))
  }
  
  /// 아티클카드
  private var articleListView: some View {
    LazyVStack(spacing: 10) {
      ForEach(store.allLinks) { link in
        let binding = Binding<Bool>(
          get: { store.selectedLinks.contains(link.id) },
          set: { _ in store.send(.toggleSelect(link)) }
        )
        
        ArticleCard(
          title: link.title,
          categoryName: link.category?.categoryName ?? "전체",
          imageURL: link.imageURL ?? "notImage",
          dateString: link.createAt.formattedKoreanDate(),
          newsCompany: link.newsCompany ?? "",
          isSelected: binding,
          editMode: .active
        )
        .id(link.id)
        .contentShape(Rectangle())
        .onTapGesture {
          store.send(.toggleSelect(link))
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 100)
  }
  
  /// 이동하기 버튼 모음
  private var bottomContents: some View {
    MainButton(
      "\(store.selectedLinks.isEmpty ? "" : "\(store.selectedLinks.count)개 ")이동하기",
      style: .deep,
      isDisabled: store.selectedLinks.isEmpty,
      hasGradient: true
    ) {
      store.send(.confirmMoveTapped)
    }
    .padding(.bottom, 8)
  }
}

private struct MoveScrollOffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
