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
  @Bindable var store: StoreOf<LinkListFeature>
  @State private var showScrollToTopButton: Bool = false
  @State private var initialOffsetY: CGFloat? = nil
}

// MARK: - View
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
        }
      }
      .toolbar(.hidden)
      .task { store.send(.onAppear) }
      .sheet(item: $store.scope(state: \.selectBottomSheet, action: \.selectBottomSheet)
      ) { selectStore in
        TCASelectBottomSheet(
          title: "카테고리 선택",
          buttonTitle: "선택하기",
          store: selectStore)
        .presentationDetents([.medium])
        .presentationCornerRadius(16)
      }
      .task {
        NotificationCenter.default.addObserver(
          forName: .linkMoved,
          object: nil,
          queue: .main
        ) { notification in
          guard
            let info = notification.object as? [String: Any]
          else { return }
          
          let count = info["movedCount"] as? Int ?? 0
          store.send(.showAlert(title: "\(count)개의 링크를 이동했어요", tint: .info))
          
          if let name = info["categoryName"] as? String {
            store.send(.moveToCategoryName(name))
          }
          store.send(.fetchLinks)
        }
      }
      .task {
        NotificationCenter.default.addObserver(
          forName: .linkDeleted,
          object: nil,
          queue: .main
        ) { notification in
          let count = (notification.object as? [String: Int])?["deletedCount"] ?? 0
          let message = count == 1 ? "링크를 삭제했어요" : "\(count)개의 링크를 삭제했어요"
          store.send(.showAlert(title: message, tint: .danger))
          store.send(.fetchLinks)
        }
      }
      .onDisappear {
        NotificationCenter.default.removeObserver(self, name: .linkMoved, object: nil)
        NotificationCenter.default.removeObserver(self, name: .linkDeleted, object: nil)
      }
    }
    .overlay {
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
    .overlay(alignment: .bottom) {
      if let alert = store.alert {
        AlertIconBanner(
          icon: alert.icon,
          title: alert.title,
          iconColor: bannerColor(alert.tint)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
      }
    }
  }
  
  /// 메인
  private var mainContents: some View {
    VStack(spacing: .zero) {
      // 상단 네비게이션바
      TopAppBarDefault(
        title: "내 링크 모음",
        onTapBackButton: { store.send(.backButtonTapped) },
        onTapSearchButton: { store.send(.searchButtonTapped) },
        onTapSettingButton: { store.send(.editButtonTapped) }
      )
      .padding(.bottom, 8)
      
      CategoryChipList(
        store: store.scope(
          state: \.categoryChipList,
          action: \.categoryChipList
        ),
        onTap: {
          store.send(.bottomSheetButtonTapped)
        }
      )
      .frame(height: 36)
      .padding(.bottom, 20)
      
      // 하단 스크롤뷰 모음
      scrollViewContents
    }
  }
  
  /// 카테고리 칩버튼 스크롤 + 기사 필터 스크롤
  private var scrollViewContents: some View {
    ScrollView(.vertical, showsIndicators: false) {
//      LazyVStack(spacing: .zero, pinnedViews: [.sectionHeaders]) {
//        Section {
      VStack(spacing: 4) {
          Color.clear
            .frame(height: 0)
            .id("top")
          
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
          
//        } header: {
//          gradientBar
//        }
      }
    }
    .coordinateSpace(name: "scroll")
    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offsetY in
      if initialOffsetY == nil {
        initialOffsetY = offsetY
      }
      
      guard let base = initialOffsetY else { return }
      
      withAnimation(.easeInOut(duration: 0.2)) {
        showScrollToTopButton = offsetY < base + 300
      }
    }
    .refreshable {
      await store.send(.refresh)
    }
  }
  
  /// 그라데이션 바
  private var gradientBar: some View {
    VStack {
      Rectangle()
        .foregroundStyle(.clear)
        .background(
          LinearGradient(
            stops: [
              Gradient.Stop(color: .bgButtonGrad1, location: 0.00),
              Gradient.Stop(color: .bgButtonGrad2, location: 0.16),
              Gradient.Stop(color: .bgButtonGrad3, location: 0.73),
              Gradient.Stop(color: .bgButtonGrad4, location: 1.00),
            ],
            startPoint: UnitPoint(x: 0, y: 0.5),
            endPoint: UnitPoint(x: 1, y: 0.5)
          )
        )
        .frame(height: 16)
    }
  }
  
  private func bannerColor(_ tint: LinkListFeature.AlertBannerState.Tint) -> Color {
    switch tint {
    case .danger:
      return .danger
    case .info:
      return .badgeColor
    case .alert:
      return .bl3
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
