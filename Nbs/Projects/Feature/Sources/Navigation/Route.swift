//
//  Route.swift
//  Feature
//
//  Created by 홍 on 10/27/25.
//

public enum Route: String {
  case home
  case myCategory
  case addLink
  case addCategory
  case setting
  case editCategory
  case editCategoryNameIcon
  case deleteCategory
  
  case linkList    // 홈 -> 링크 리스트
  case linkDetail  // 카드 -> 링크 디테일
  
  case originalArticle // 링크 디테일 -> 원문 보기
}
