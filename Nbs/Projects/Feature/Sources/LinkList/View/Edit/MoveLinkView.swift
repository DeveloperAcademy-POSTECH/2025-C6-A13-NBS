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
    ScrollViewReader { proxy in
      ZStack(alignment: .bottomTrailing) {
        Color.background.ignoresSafeArea()
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
        .padding(.bottom, 50)
      }
      .onPreferenceChange(MoveScrollOffsetKey.self) { offsetY in
        withAnimation(.easeInOut(duration: 0.2)) {
          showScrollToTopButton = offsetY < -200
        }
      }
      .sheet(
         store: store.scope(state: \.$selectBottomSheet, action: \.selectBottomSheet)
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
  
  /// 이동할 링크 선택 텍스트
  private var topContents: some View {
    Text(
      store.selectedLinks.isEmpty
      ? "이동할 링크를 선택해주세요"
      : "\(store.selectedLinks.count)개의 링크가 선택됐어요"
    )
    .font(.H4_SB)
    .foregroundStyle(.text1)
    .padding(.vertical, 18)
    .padding(.horizontal, 20)
  }
  
  private var middleContents: some View {
    ScrollView() {
      VStack(spacing: 0) {
        Color.clear.frame(height: 0).id("moveTop")
        linkSelectView
        articleListView
          .background(
            GeometryReader { geo in
              Color.clear.preference(
                key: MoveScrollOffsetKey.self,
                value: geo.frame(in: .named("moveScroll")).minY
              )
            }
              .frame(height: 0)
          )
      }
    }
    .coordinateSpace(name: "moveScroll")
    .scrollIndicators(.hidden)
  }
  
  /// 링크 개수 + 선택
  private var linkSelectView: some View {
    HStack(spacing: 4) {
      CheckboxButton(isOn: $store.isSelectAll)
      
      Text("모두 선택")
        .font(.B2_SB)
        .foregroundStyle(.caption1)
      
      Spacer()
      
      Text("전체 (\(store.allLinks.count)개)")
        .font(.B2_M)
        .foregroundStyle(.caption3)
    }
    .padding(EdgeInsets(top: 8, leading: 20, bottom: 12, trailing: 20))
  }
  
  /// 아티클카드
  private var articleListView: some View {
    LazyVStack(spacing: 12) {
      ForEach(store.allLinks) { link in
        let binding = Binding<Bool>(
          get: { store.selectedLinks.contains(link.id) },
          set: { _ in store.send(.toggleSelect(link)) }
        )
        
        ArticleCard(
          title: link.title,
          categoryName: link.category?.categoryName,
          imageURL: link.imageURL,
          dateString: link.createAt.formattedKoreanDate(),
          newsCompany: link.newsCompany,
          isSelected: binding,
          editMode: .active
        )
        .id(link.id)
      }
    }
    .padding(.horizontal, 20)
  }
  
  /// 취소 + 이동하기 버튼 모음
  private var bottomContents: some View {
    HStack(spacing: 12) {
      MainButton("취소", style: .soft) {
        store.send(.cancelTapped)
      }
      
      MainButton("이동하기", style: .deep, isDisabled: store.selectedLinks.isEmpty
      ) {
        store.send(.confirmMoveTapped)
      }
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 14)
  }
}

private struct MoveScrollOffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
