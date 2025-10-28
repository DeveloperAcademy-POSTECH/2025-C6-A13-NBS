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

/// 링크 리스트 뷰
struct LinkListView {
  @Environment(\.dismiss) private var dismiss
  let store: StoreOf<LinkListFeature>
  @State private var showScrollToTopButton: Bool = false
  @State private var baseOffset: CGFloat? = nil
}

// MARK: - Body
extension LinkListView: View {
  var body: some View {
    ZStack {
      Color.background
        .ignoresSafeArea()
      ScrollViewReader { proxy in
        ZStack(alignment: .bottomTrailing) {
          mainContents
          ScrollFloatingButton(
            isVisible: $showScrollToTopButton,
            proxy: proxy,
            targetID: "top"
          )
          
          IfLetStore(
            store.scope(state: \.$editSheet, action: \.editSheet)
          ) { editStore in
            ActionBottomSheet(onDismiss: {
              // 닫기 버튼이나 배경 탭 시
              store.send(.editSheet(.dismiss))
            }) {
              LinkEditSheetView(store: editStore)
            }
            .zIndex(2)
          }
        }
      }
      .fullScreenCover(
        store: store.scope(state: \.$moveLink, action: \.moveLink)
      ) { moveStore in
        MoveLinkView(store: moveStore)
      }
      .fullScreenCover(
        store: store.scope(state: \.$deleteLink, action: \.deleteLink)
      ) { deleteStore in
        DeleteLinkView(store: deleteStore)
      }
      .sheet(
        store: store.scope(state: \.$selectBottomSheet, action: \.selectBottomSheet)
      ) { selectStore in
        TCASelectBottomSheet(title: "카테고리 선택", store: selectStore)
          .presentationDetents([.medium])
          .presentationCornerRadius(16)
      }
      
      .navigationBarHidden(true)
      .onAppear {
        store.send(.onAppear)
      }
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
          // 링크 편집 시트 띄우기
          store.send(.editButtonTapped)
        }
      )
      // 하단 스크롤뷰 모음
      scrollViewContents
    }
  }
  
  /// 카테고리 칩버튼 스크롤 + 기사 필터 스크롤
  private var scrollViewContents: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 4) {
        Color.clear
          .frame(height: 0)
          .id("top")
        
        CategoryChipList(
          store: store.scope(
            state: \.categoryChipList,
            action: \.categoryChipList
          ),
          onTap: {
//            store.send(.bottomSheetButtonTapped)
          }
        )
        .padding(.bottom, 16)
        
        ArticleFilterList(
          store: store.scope(
            state: \.articleList,
            action: \.articleList
          )
        )
        
        GeometryReader { geo in
          Color.clear
            .preference(
              key: ScrollOffsetPreferenceKey.self,
              value: geo.frame(in: .named("scroll")).minY
            )
        }
        .frame(height: 0)
      }
    }
    .coordinateSpace(name: "scroll")
    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offsetY in
      withAnimation(.easeInOut(duration: 0.2)) {
        if offsetY < 1300 {
          showScrollToTopButton = true
        } else if offsetY > 1550 {
          showScrollToTopButton = false
        }
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
