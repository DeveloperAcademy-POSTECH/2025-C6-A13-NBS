//
//  OriginalArticleView.swift
//  Feature
//
//  Created by 여성일 on 10/31/25.
//

import SwiftUI

import DesignSystem

// MARK: - Properties
struct OriginalArticleView: View {
  let url: URL
}

// MARK: - View
extension OriginalArticleView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      VStack {
        OriginalHeaderView()

        OriginalWebView(url: url)
          .ignoresSafeArea(edges: .bottom)
      }
    }
  }
}

#Preview {
  
  OriginalArticleView(url: URL(string: "https://www.google.com")!)
}
