//
//  OriginalArticleView.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem


// MARK: - Properties
struct OriginalArticleView: View {
  let store: StoreOf<OriginalArticleFeature>
}

// MARK: - View
extension OriginalArticleView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack {
        OriginalHeaderView(headerType: .article, onEditTapped: {
          store.send(.editButtonTapped)
        })
        OriginalWebView(url: store.url)
          .ignoresSafeArea(edges: .bottom)
      }
    }
  }
}
