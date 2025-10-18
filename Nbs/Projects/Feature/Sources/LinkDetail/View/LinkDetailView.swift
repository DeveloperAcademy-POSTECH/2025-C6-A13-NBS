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
  let store: StoreOf<LinkDetailFeature>
}

extension LinkDetailView: View {
  var body: some View {
    VStack(spacing: 16) {
      TopAppBarDefault(
        title: "링크 상세",
        onTapBackButton: { dismiss()}, // 상위 NavigationStack에서 처리됨
        onTapSearchButton: {},
        onTapSettingButton: {}
      )
      .padding(.bottom, 8)
      
      Spacer()
      
      Text("📰 \(store.articleTitle.isEmpty ? "헬로우" : store.articleTitle)")
        .font(.title2)
        .foregroundColor(.primary)
      
      Spacer()
    }
    .navigationBarHidden(true)
  }
}
