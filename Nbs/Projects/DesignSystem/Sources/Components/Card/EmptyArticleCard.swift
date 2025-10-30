//
//  EmptyArticleCard.swift
//  DesignSystem
//
//  Created by 홍 on 10/29/25.
//

import SwiftUI

public struct EmptyArticleCard {
  
  let type: CardTyoe
  
  public enum CardTyoe {
    ///아직 저장한 링크가 없어요
    case noLinks
    ///최근 검색어가 아직 없어요
    case noRecentSearch
    ///관련 링크를 찾을 수 없어요다른 단어로 검색해보세요
    case noSearchResult(searchText: String)
  }
  
  public init(type: CardTyoe) {
    self.type = type
  }
}

extension EmptyArticleCard: View {
  public var body: some View {
    VStack(spacing: 20) {
      Image(uiImage: DesignSystemAsset.emptyLinkIcon.image)
        .resizable()
        .frame(width: 120, height: 120)
      Text("아직 저장한 링크가 없어요")
        .font(.B1_M)
        .foregroundStyle(.caption3)
    }
  }
  
  private var titleText: String {
    switch type {
    case .noLinks:
      return "아직 저장한 링크가 없어요"
    case .noRecentSearch:
      return "최근 검색어가 아직 없어요"
    case .noSearchResult(let text):
      return "‘\(text)’ 관련 링크를 찾을 수 없어요\n다른 단어로 검색해보세요"
    }
  }
}
