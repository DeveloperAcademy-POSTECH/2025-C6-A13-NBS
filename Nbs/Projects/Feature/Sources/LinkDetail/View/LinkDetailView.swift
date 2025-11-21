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
            LazyVStack(spacing: .zero, pinnedViews: [.sectionHeaders]) {
              Section(header:  LinkDetailSegment(selectedTab: $selectedTab)) {
                bottomContents
              }
            }
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
          title: "해당 링크를 삭제할까요?",
          subtitle: "삭제한 링크는 복구할 수 없어요",
          cancelTitle: "취소",
          onCancel: { showAlertDialog = false },
          buttonType: .delete(title: "삭제") {
            showAlertDialog = false
            store.send(.deleteTapped)
          }
        )
      }
      
      VStack {
        Spacer()
        if(store.showToast) {
          AlertIconBanner(
            icon: Image(icon: Icon.badgeCheck),
            title: "링크를 수정했어요",
            iconColor: .badgeColor
          )
          .zIndex(1)
          .padding(.horizontal, 20)
          .padding(.bottom, 12)
        }
      }
      .animation(.easeInOut, value: store.showToast)
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
        // 편집중 일때
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
          Button {
            store.send(.editButtonTapped)
            DispatchQueue.main.async { titleFocused = true }
          } label: {
            Text(store.link.title)
              .font(.H1)
              .foregroundStyle(.text1)
              .multilineTextAlignment(.leading)
              .lineLimit(nil)
          }
          .buttonStyle(.plain)
        }
        
        Spacer()
        
        if !store.isEditingTitle && !titleFocused {
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
      }
      
      // 정보 섹션
      VStack(alignment: .leading, spacing: 12) {
        ArticleInfoItem(icon: Icon.calendar, text: store.link.createAt.formattedKoreanDate())
        ArticleInfoItem(
          icon: Icon.book,
          text: (store.link.newsCompany?.isEmpty == false) ? store.link.newsCompany! : "언론사 없음"
        )
        ArticleInfoItem(icon: Icon.tag, text: store.link.category?.categoryName ?? "전체")
      }
    }
  }
  
  /// 링크 원문 보기
  private var articleLink: some View {
    Button {
      store.send(.originalArticleTapped)
    } label: {
      HStack(spacing: 12) {
        articleImage
        
        VStack(alignment: .leading, spacing: 4) {
          Text("원문 보기 및 수정하기")
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
          .allowsHitTesting(false)
      }
    }
    .buttonStyle(.plain)
  }
  
  /// 기사 이미지
  private var articleImage: some View {
    AsyncImage(url: URL(string: store.link.imageURL ?? "")) { phase in
      switch phase {
      case .empty:
        ProgressView()
          .frame(width: 48, height: 48)
          .cornerRadius(8)
      case .success(let image):
        image
          .resizable()
          .scaledToFill()
          .frame(width: 48, height: 48)
          .cornerRadius(8)
          .clipped()
          .clipShape(RoundedRectangle(cornerRadius: 6))
      case .failure:
        DesignSystemAsset.notImage.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 48, height: 48)
          .foregroundColor(.gray)
          .clipped()
          .clipShape(RoundedRectangle(cornerRadius: 6))
      @unknown default:
        EmptyView()
      }
    }
  }
  
  /// 하이라이트 + 추가메모
  private var bottomContents: some View {
    VStack {
      switch selectedTab {
      case .summary:
        if store.link.highlights.isEmpty {
          EmptyLinkDetailView()
            .padding(.top, 80)
        } else {
          SummaryView(link: store.link, store: store.scope(state: \.summary, action: \.summary))
        }
      case .memo:
        ZStack(alignment: .bottom) {
          AddMemoView(
            text: Binding(
              get: { store.editedMemo },
              set: { store.send(.memoChanged($0)) }
            ),
            onFocusChanged: { hasFocus in
              store.send(.memoFocusChanged(hasFocus))
            },
            onDone: {
              store.send(.memoFocusChanged(false))
            }
          )
          .padding(20)
          
          Rectangle()
          //            .foregroundStyle(.clear)
            .fill(
              LinearGradient(
                stops: [
                  Gradient.Stop(color: .bgButtonGrad1, location: 0.00),
                  Gradient.Stop(color: .bgButtonGrad2, location: 0.16),
                  Gradient.Stop(color: .bgButtonGrad3, location: 0.73),
                  Gradient.Stop(color: .bgButtonGrad4, location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.47, y: 1),
                endPoint: UnitPoint(x: 0.47, y: 0.15)
              )
            )
            .frame(height: 60)
        }
      }
    }
  }
}
