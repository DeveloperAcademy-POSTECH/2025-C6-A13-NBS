//
//  ArticleFilterRow.swift
//  Feature
//
//  Created by 이안 on 10/27/25.
//

import SwiftUI
import ComposableArchitecture
import Domain
import DesignSystem

struct ArticleRowView: View {
  let article: ArticleItem
  @Bindable var store: StoreOf<ArticleFilterFeature>
  @State private var didLongPress = false

  var body: some View {
    ArticleCard(
      title: article.title,
      categoryName: article.category?.categoryName,
      imageURL: article.imageURL ?? "notImage",
      dateString: article.createAt.formattedKoreanDate()
    )
    .contentShape(Rectangle())
    .background(Color.clear)
    .simultaneousGesture(
      TapGesture().onEnded {
        if !didLongPress {
          store.send(.listCellTapped(article))
        }
        didLongPress = false
      }
    )
    .simultaneousGesture(
      LongPressGesture(minimumDuration: 0.5)
        .onEnded { _ in
          didLongPress = true
          store.send(.listCellLongPressed(article))
        }
    )
  }
}
