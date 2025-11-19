//
//  Route.swift
//  Feature
//
//  Created by 홍 on 10/27/25.
//

public enum Route: String, Codable {
  
  //MARK: 온보딩
  case onboardingService
  case onboarding
  case safariSetting
  case highlightMemoGuide
  case onboardingHighlight
  case safariSave
  case safariShare
  case startApp

  case home
  case myCategory
  case addLink
  case addCategory
  case categorySetting
  case editCategory
  case editCategoryNameIcon
  case deleteCategory
  case search
  case linkList    // 홈 -> 링크 리스트
  case linkDetail  // 카드 -> 링크 디테일
  case originalArticle // 링크 디테일 -> 원문 보기
  case originalEdit // 원문 보기 -> 원문 편집
  case moveLink    // 링크 이동하기
  case deleteLink  // 링크 삭제하기
  
  // MARK: - 설정
  case setting // 홈 -> 설정
  case policyDetail // 설정 -> 정책 디테일
  case openSourceList // 설정 -> 오픈소스 리스트
  case favoriteSetting
  case extensionSetting
  case shareSetting
}
