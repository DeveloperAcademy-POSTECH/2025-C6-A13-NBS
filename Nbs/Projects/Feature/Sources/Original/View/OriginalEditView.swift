//
//  OriginalEditView.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem


// MARK: - Properties
struct OriginalEditView: View {
  let store: StoreOf<OriginalEditFeature>
}

// MARK: - View
extension OriginalEditView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack {
        OriginalHeaderView(headerType: .edit, onCompleteTapped:  {
          
        })
        OriginalWebView(url: store.url)
          .ignoresSafeArea(edges: .bottom)
      }
    }
  }
}

