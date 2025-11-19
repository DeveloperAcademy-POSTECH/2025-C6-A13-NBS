//
//  HeaderNamespace.swift
//  DesignSystem
//
//  Created by 홍 on 10/28/25.
//

public enum HeaderNamespace {}

extension HeaderNamespace {
  public enum ButtonTitle: String {
    ///더보기
    case showMore = "더보기"
  }
}

extension HeaderNamespace {
  public enum HeaderTitle: String {
    ///카테고리별 보기
    case showCategory = "카테고리별 보기"
    ///최근 추가한 링크
    case recentAddLink = "최근 추가한 링크"
    ///추가할 링크
    case addLink = "추가할 링크"
    ///카테고리 선택
    case selectCategory = "카테고리 선택"
    ///카테고리명
    case categoryName = "카테고리명"
    ///카테고리 아이콘
    case categoryIcon = "카테고리 아이콘"
  }
}
