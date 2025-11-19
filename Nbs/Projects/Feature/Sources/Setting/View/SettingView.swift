//
//  SettingView.swift
//  Feature
//
//  Created by 이안 on 11/5/25.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem
import Domain

/// 앱 메인 설정뷰
struct SettingView {
  @Environment(\.openURL) private var openURL
  
  let store: StoreOf<SettingFeature>
}

// MARK: View
extension SettingView: View {
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      
      VStack {
        navigationBar
        scrollView
      }
    }
    .navigationBarHidden(true)
  }
  
  private var navigationBar: some View {
    TopAppBarDefaultRightIconx(title: "설정") {
      store.send(.backButtonTapped)
    }
  }
  
  private var scrollView: some View {
    ScrollView(.vertical, showsIndicators: false) {
      topContents
      
      Rectangle()
        .fill(.divider1)
        .frame(height: 1)
      
      bottomContents
    }
    .padding(.horizontal, 20)
  }
  
  private var topContents: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("알아두면 좋은 팁")
        .font(.B2_M)
        .foregroundStyle(.caption1)
        .multilineTextAlignment(.leading)
        .frame(height: 32)
      
      tipGrid
    }
    .padding(.bottom, 24)
  }
  
  private var tipGrid: some View {
    LazyVGrid(
      columns: [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
      ],
      spacing: 12
    ) {
      SettingTipCard(
        icon: DesignSystemAsset.settingSafari.swiftUIImage,
        title: "Safari extension 허용하기"
      ) {
        store.send(.safariTipTapped)
      }
      
      SettingTipCard(
        icon: DesignSystemAsset.settingHighlight.swiftUIImage,
        title: "하이라이트 및 메모 \n연습하기"
      ) {
        store.send(.highlightTipTapped)
      }
      
      SettingTipCard(
        icon: DesignSystemAsset.settingShare.swiftUIImage,
        title: "우리앱으로 손쉽게 \n공유하기"
      ) {
        store.send(.shareTipTapped)
      }
      
      SettingTipCard(
        icon: DesignSystemAsset.settingFavorite.swiftUIImage,
        title: "즐겨찾기 설정하기"
      ) {
        store.send(.favoriteTipTapped)
      }
    }
  }
  
  private var bottomContents: some View {
    VStack(alignment: .leading, spacing: .zero) {
      Text("정보")
        .font(.B2_M)
        .foregroundStyle(.caption1)
        .multilineTextAlignment(.leading)
        .frame(height: 32)
      
      infoList
        .padding(.bottom, 16)
      teamInfo
    }
    .padding(.top, 12)
  }
  
  private var infoList: some View {
    VStack(spacing: .zero) {
      InfoListItem(
        icon: Icon.info,
        title: "앱 버전",
        trailing: .text { Constants.appVersion }
      )
      
      InfoListItem(
        icon: Icon.shield, title: "개인정보 처리방침",
        trailing: .chevron
      ) {
        store.send(.privacyPolicyTapped)
      }
      
      InfoListItem(
        icon: Icon.file, title: "서비스 이용약관",
        trailing: .chevron
      ) {
        store.send(.termsOfServiceTapped)
      }
      
      InfoListItem(
        icon: Icon.opensource,
        title: "사용된 오픈 소스",
        trailing: .chevron
      ) {
        store.send(.openSourceTapped)
      }
      
      InfoListItem(
        icon: Icon.heart,
        title: "탭탭 서비스 소개",
        trailing: .chevron
      ) {
        if let url = URL(string: Constants.notionLink) {
          openURL(url)
        }
        
        store.send(.openLinkTapped)
      }
    }
  }
  
  private var teamInfo: some View {
    VStack(alignment: .leading, spacing: .zero) {
      Rectangle()
        .fill(.divider1)
        .frame(height: 1)
        .padding(.bottom, 24)
      
      Group{
        Text("Designed by 조혜준, 진서영.")
        Text("Developed by 김윤홍, 여성일, 이승진.")
        Text("Managed by 신지현.")
      }
      .font(.C2)
      .foregroundStyle(.caption3)
    }
    .padding(.bottom, 68)
  }
}

#Preview {
  SettingView(store: Store(initialState: SettingFeature.State(), reducer: {
    SettingFeature()
  }))
}
