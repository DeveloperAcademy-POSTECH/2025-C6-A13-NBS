//
//  LinkDetailView.swift
//  Feature
//
//  Created by 이안 on 10/19/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct LinkDetailView {
  @Environment(\.dismiss) private var dismiss
  @Bindable var store: StoreOf<LinkDetailFeature>
  @State private var selectedTab: LinkDetailSegment.Tab = .summary

}

extension LinkDetailView: View {
  var body: some View {
    ZStack {
      Color.background
        .ignoresSafeArea()
      VStack {
        navigationBar
        ScrollView {
          LazyVStack(spacing: 24) {
            articleContensts
            bottomContents
          }
        }
      }
      .navigationBarHidden(true)
      .onAppear { store.send(.onAppear) }
    }
  }
  
  /// 네비게이션바
  private var navigationBar: some View {
    TopAppBarDefault(
      title: "",
      onTapBackButton: { dismiss() },
      onTapSearchButton: {},
      onTapSettingButton: {}
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
      Text(store.article.title)
        .font(.H1)
        .foregroundStyle(.text1)
        .multilineTextAlignment(.leading)
        .lineLimit(nil)
      
      // 정보 섹션
      VStack(alignment: .leading, spacing: 12) {
        ArticleInfoItem(icon: Icon.calendar, text: store.article.dateToString)
        ArticleInfoItem(icon: Icon.book, text: store.article.newsCompany)
        ArticleInfoItem(icon: Icon.tag, text: "뉴스 카테고리")
      }
    }
  }
  
  /// 링크 원문 보기
  private var articleLink: some View {
    Button {
      if let url = store.article.url,
         let link = URL(string: url) {
        UIApplication.shared.open(link)
      }
    } label: {
      HStack(spacing: 12) {
        Image(systemName: "photo")
          .resizable()
          .scaledToFit()
          .frame(width: 48, height: 48)
          .cornerRadius(8)
        
        VStack(alignment: .leading, spacing: 4) {
          Text("링크 원문 보기")
            .font(.B1_M)
            .foregroundStyle(.text1)
            .lineLimit(1)
          
          if let url = store.article.url {
            Text(url)
              .lineLimit(1)
              .font(.C2)
              .foregroundStyle(.caption2)
          }
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
        .frame(height: 37)

      switch selectedTab {
      case .summary:
        SummaryView(highlights: MockHighlightItem.mockData)
      case .memo:
        AddMemoView()
      }
    }
  }
}

#Preview {
  LinkDetailView(
    store: Store(
      initialState: LinkDetailFeature.State(
        article: MockArticle.mockArticles.first!
      )
    ) {
      LinkDetailFeature()
    }
  )
}
