//
//  LinkListView.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import SwiftUI
import ComposableArchitecture
import Domain
import DesignSystem

struct LinkListView {
  @Environment(\.dismiss) private var dismiss
  let store: StoreOf<LinkListFeature>
  @State private var showScrollToTopButton: Bool = false
}

extension LinkListView: View {
  var body: some View {
    ScrollViewReader { proxy in
      ZStack(alignment: .bottomTrailing) {
        mainContents
        ScrollFloatingButton(
          isVisible: $showScrollToTopButton,
          proxy: proxy,
          targetID: "top"
        )
      }
    }
    .navigationBarHidden(true)
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  /// 메인
  private var mainContents: some View {
    VStack(spacing: .zero) {
      // 상단 네비게이션바
      TopAppBarDefault(
        title: "내 링크 모음",
        onTapBackButton: { dismiss() },
        onTapSearchButton: {
          // TODO: 검색 화면 연결
          print("검색 버튼 클릭")
        },
        onTapSettingButton: {
          // TODO: 설정 화면 연결
          print("설정 버튼 클릭")
        }
      )
      // 하단 스크롤뷰 모음
      scrollViewContents
    }
  }
  
  /// 카테고리 칩버튼 스크롤 + 기사 필터 스크롤
  private var scrollViewContents: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack(spacing: 4) {
        Color.clear
          .frame(height: 0)
          .id("top")
        
        GeometryReader { geo in
          Color.clear
            .preference(
              key: ScrollOffsetPreferenceKey.self,
              value: geo.frame(in: .named("scroll")).minY
            )
        }
        .frame(height: 0)
        
        CategoryChipList(
          store: store.scope(
            state: \.categoryChipList,
            action: \.categoryChipList
          ),
          onTap: {
            store.send(.bottomSheetButtonTapped(true))
          }
        )
        
        ArticleFilterList(
          store: store.scope(
            state: \.articleList,
            action: \.articleList
          )
        )
      }
      .coordinateSpace(name: "scroll")
      .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offsetY in
        // 아래로 200 이상 스크롤 할 경우 보여주기
//        withAnimation(.easeInOut(duration: 0.2)) {
//          showScrollToTopButton = offsetY < -200
//        }
        showScrollToTopButton = true
      }
    }
  }
}

/// ScrollView의 스크롤 오프셋을 추적하기 위한 PreferenceKey
private struct ScrollOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

#Preview {
  LinkListView(
    store: Store(
      initialState: LinkListFeature.State()
    ) {
      LinkListFeature()
    }
  )
}
