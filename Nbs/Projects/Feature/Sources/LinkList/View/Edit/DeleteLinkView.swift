//
//  DeleteLinkView.swift
//  Feature
//
//  Created by 이안 on 10/22/25.
//

import SwiftUI
import ComposableArchitecture
import Domain
import DesignSystem

struct DeleteLinkView: View {
  @Bindable var store: StoreOf<DeleteLinkFeature>
  @State private var showScrollToTopButton = false
  @State private var showAlertDialog = false
}

extension DeleteLinkView {
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
      .overlay {
        if showAlertDialog {
          Color.dim
            .ignoresSafeArea()
            .onTapGesture { showAlertDialog = false }
          
          AlertDialog(
            title: "선택한 링크를 삭제할까요?",
            subtitle: "삭제한 링크는 복구할 수 없어요",
            cancelTitle: "취소",
            onCancel: {
              showAlertDialog = false
            },
            buttonType: .delete(title: "삭제") {
              showAlertDialog = false
              store.send(.confirmDeleteTapped)
            }
          )
        }
      }
      .animation(.easeInOut(duration: 0.25), value: showAlertDialog)
    }
  }
  
  /// 링크 삭제하기 네비게이션바
  private var topContents: some View {
    TopAppBarDefaultRightIconx(title: "링크 삭제하기") {
      store.send(.backButtonTapped)
    }
  }
  
  private var middleContents: some View {
    ScrollView {
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
  }
  
  /// 링크 개수 + 선택
  private var linkSelectView: some View {
    HStack(spacing: 4) {
      CheckboxButton(isOn: $store.isSelectAll, style: .clear)
      
      Text("모두 선택")
        .font(.B2_SB)
        .foregroundStyle(.caption1)
      
      Spacer()
      
      Text("\(store.categoryName) (\(store.allLinks.count)개)")
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
          categoryName: link.category?.categoryName ?? "전체",
          imageURL: link.imageURL ?? "notImage",
          dateString: link.createAt.formattedKoreanDate(),
          newsCompany: link.newsCompany ?? "언론사 없음",
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
  }
  
  /// 취소 + 삭제하기 버튼 모음
  private var bottomContents: some View {
    MainButton(
      "\(store.selectedLinks.isEmpty ? "" : "(\(store.selectedLinks.count))개 " )삭제하기",
      style: .danger,
      isDisabled: store.selectedLinks.isEmpty,
      hasGradient: true
    ) {
      showAlertDialog = true
    }
  }
}

private struct MoveScrollOffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
