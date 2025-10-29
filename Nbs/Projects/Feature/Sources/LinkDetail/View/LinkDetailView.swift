//
//  LinkDetailView.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

struct LinkDetailView {
  @Environment(\.dismiss) private var dismiss
  @Bindable var store: StoreOf<LinkDetailFeature>
  @State private var selectedTab: LinkDetailSegment.Tab = .summary
  @FocusState private var titleFocused: Bool
  @State private var showAlertDialog = false
}

extension LinkDetailView: View {
  var body: some View {
    ZStack {
      Color.background
        .ignoresSafeArea()
      VStack {
        navigationBar
        ScrollView(.vertical, showsIndicators: false) {
          LazyVStack(spacing: 24) {
            articleContensts
            bottomContents
          }
        }
        .scrollIndicators(.hidden)
      }
      .navigationBarHidden(true)
      .onAppear { store.send(.onAppear) }
      .onChange(of: titleFocused) { _, hasFocus in
        store.send(.titleFocusChanged(hasFocus))
      }
      .onChange(of: store.isDeleted) { _, deleted in
        if deleted { dismiss() }
      }
      if showAlertDialog {
        Color.dim
          .ignoresSafeArea()
          .onTapGesture { showAlertDialog = false }
        
        AlertDialog(
          title: "이 링크를 삭제하시겠어요?",
          subtitle: "삭제한 링크는 복구할 수 없어요",
          cancelTitle: "취소",
          onCancel: { showAlertDialog = false },
          buttonType: .delete(title: "삭제") {
            showAlertDialog = false
            store.send(.deleteTapped)
          }
        )
      }
    }
  }
  
  /// 네비게이션바
  private var navigationBar: some View {
    TopAppBarDefaultDetail(
      title: "",
      onTapBackButton: { dismiss() },
      onTapSearchButton: {},
      onTapSettingButton: { showAlertDialog = true }
    )
  }
  
  /// 상단 컨텐츠
  private var articleContensts: some View {
    VStack(alignment: .leading, spacing: 24) {
      articleInfo
      articleLink
    }
    .padding(.horizontal, 20)
  }
  
  /// 기사 타이틀 + 정보 섹션
  private var articleInfo: some View {
    VStack(alignment: .leading, spacing: 24) {
      // 기사 타이틀
      HStack(alignment: .firstTextBaseline, spacing: 12) {
        if store.isEditingTitle || titleFocused {
          TextField(
            "제목",
            text: Binding(
              get: { store.editedTitle },
              set: { store.send(.titleChanged($0)) }
            )
          )
          .focused($titleFocused)
          .submitLabel(.done)
          .onSubmit { titleFocused = false }
        } else {
          Text(store.link.title)
            .font(.H1)
            .foregroundStyle(.text1)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
        }
        
        Spacer()
        
        Button {
          store.send(.editButtonTapped)
          DispatchQueue.main.async { titleFocused = true }
        } label: {
          Image(icon: Icon.edit)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .contentShape(Rectangle())
            .foregroundStyle(.iconGray)
        }
        .buttonStyle(.plain)
      }
      
      // 정보 섹션
      VStack(alignment: .leading, spacing: 12) {
        ArticleInfoItem(icon: Icon.calendar, text: store.link.createAt.formattedKoreanDate())
        ArticleInfoItem(icon: Icon.book, text: "네이버 뉴스")
        ArticleInfoItem(icon: Icon.tag, text: store.link.category?.categoryName ?? "카테고리 없음")
      }
    }
  }
  
  /// 링크 원문 보기
  private var articleLink: some View {
    Button {
      if let url = URL(string: store.link.urlString) {
        UIApplication.shared.open(url)
      }
    } label: {
      HStack(spacing: 12) {
        DesignSystemAsset.notImage.swiftUIImage
          .resizable()
          .scaledToFit()
          .frame(width: 48, height: 48)
          .cornerRadius(8)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("링크 원문 보기")
            .font(.B1_M)
            .foregroundStyle(.text1)
            .lineLimit(1)
          
          Text(store.link.urlString)
            .lineLimit(1)
            .font(.C2)
            .foregroundStyle(.caption2)
        }
        
        Spacer()
        
        Image(icon: Icon.chevronRight)
          .renderingMode(.template)
          .resizable()
          .scaledToFit()
          .foregroundStyle(.icon)
          .frame(width: 24, height: 24)
      }
      .padding(12)
      .background {
        RoundedRectangle(cornerRadius: 12)
          .fill(.n0)
      }
    }
    .buttonStyle(.plain)
  }
  
  private var bottomContents: some View {
    VStack {
      LinkDetailSegment(selectedTab: $selectedTab)
        .frame(height: 45)
      
      switch selectedTab {
      case .summary:
        if store.link.highlights.isEmpty {
          EmptyLinkDetailView()
            .padding(.top, 80)
        } else {
          SummaryView(link: store.link)
        }
      case .memo:
        AddMemoView(
          text: Binding(
            get: { store.editedMemo },
            set: { store.send(.memoChanged($0)) }
          ),
          onFocusChanged: { hasFocus in
            store.send(.memoFocusChanged(hasFocus))
          }
        )
        .padding(20)
      }
    }
  }
}
