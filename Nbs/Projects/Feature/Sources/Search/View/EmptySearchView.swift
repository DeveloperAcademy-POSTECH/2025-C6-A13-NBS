//
//  EmptySearchView.swift
//  Feature
//
//  Created by 여성일 on 10/19/25.
//

import SwiftUI

import DesignSystem

// MARK: - Properties
struct EmptySearchView: View {
  enum EmptySearchType {
    case emptyRecentSearch
    case emptyResult(searchTerm: String)
  }
  
  let type: EmptySearchType
  
  var title: String {
    switch type {
    case .emptyRecentSearch:
      return "최근 검색어가 아직 없어요"
    case .emptyResult(let searchTerm):
      return "'\(searchTerm.truncatedString(count: 7))' 관련 링크를 찾을 수 없어요\n다른 단어로 검색해보세요"
    }
  }
}

// MARK: - View
extension EmptySearchView {
  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .center) {
        Image(icon: "emptyLinkIcon")
          .frame(width: 120, height: 120)
          .padding(.bottom, 20)
        Text(title)
          .font(.B1_M)
          .multilineTextAlignment(.center)
          .lineLimit(2)
          .foregroundStyle(.caption3)
          .padding(.bottom, 50)
      }
    }
    .frame(maxWidth: .infinity)
    .frame(maxHeight: .infinity)
    .padding(.top, 8)

  }
}

#Preview {
  EmptySearchView(type: .emptyRecentSearch)
}
