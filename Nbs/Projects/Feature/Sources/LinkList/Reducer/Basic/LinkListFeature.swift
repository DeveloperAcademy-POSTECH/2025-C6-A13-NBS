//
//  LinkListFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import SwiftUI
import ComposableArchitecture
import Domain
import DesignSystem
import LinkNavigator

@Reducer
struct LinkListFeature {
  // MARK: - Dependencies
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.uuid) var uuid
  @Dependency(\.linkNavigator) var linkNavigator
  
  // MARK: - State
  @ObservableState
  struct State {
    // 자식 Feature 상태
    var categoryChipList = CategoryChipFeature.State()
    var articleList = ArticleFilterFeature.State()
    var allLinks: [ArticleItem] = []
    var showBottomSheet: Bool = false // 카테고리 선택 시트
    var selectedCategory: CategoryItem? = nil
    
    var selectedCategoryTitle: String = "카테고리"
    var alert: AlertBannerState? = nil
    
    // 시트 상태 관리
    @Presents var editSheet: EditSheetFeature.State?
    @Presents var selectBottomSheet: SelectBottomSheetFeature.State?
  }
  
  struct AlertBannerState: Equatable {
    let title: String
    let icon: Image
    let tint: Tint
    enum Tint: Equatable { case danger, info, alert }
  }
  
  // MARK: - Action
  enum Action {
    /// 라이프사이클
    case onAppear
    
    /// 자식 Feature 액션
    case categoryChipList(CategoryChipFeature.Action)
    case articleList(ArticleFilterFeature.Action)
    
    /// UI 이벤트
    case bottomSheetButtonTapped
    case linkLongPressed(ArticleItem)
    case editButtonTapped
    case backButtonTapped
    case searchButtonTapped
    case refresh
    case moveToCategoryName(String)
    
    /// 시트 관련 액션
    case editSheet(PresentationAction<EditSheetFeature.Action>)
    case selectBottomSheet(PresentationAction<SelectBottomSheetFeature.Action>)
    
    /// 알럿 관련 액션
    case hideAlertBanner
    case showAlert(title: String, tint: AlertBannerState.Tint)
    
    /// 데이터 로드 관련
    case fetchLinks
    case fetchLinksResponse(Result<[ArticleItem], Error>)
    case fetchCategories
    case responseCategoryItems([CategoryItem])
  }
  
  // MARK: - Body
  var body: some ReducerOf<Self> {
    /// 자식 리듀서 연결
    Scope(state: \.categoryChipList, action: \.categoryChipList) {
      CategoryChipFeature()
    }
    
    Scope(state: \.articleList, action: \.articleList) {
      ArticleFilterFeature()
    }
    
    /// UI 처리 전용 Reducer
    Reduce(self.uiReducer)
      .ifLet(\.$editSheet, action: \.editSheet) { EditSheetFeature() }
      .ifLet(\.$selectBottomSheet, action: \.selectBottomSheet) { SelectBottomSheetFeature() }
    
    /// 데이터 로드 전용 Reducer
    Reduce(self.dataReducer)
  }
}

// MARK: - UI Reducer
private extension LinkListFeature {
  func uiReducer(state: inout State, action: Action) -> Effect<Action> {
    switch action {
      
      /// 초기 진입 시 링크 데이터 요청
    case .onAppear:
      if let selected = state.selectedCategory {
        state.categoryChipList.selectedCategory = selected
      }
      return .send(.fetchLinks)
      
    case .backButtonTapped:
      return .run { _ in
        await linkNavigator.pop()
      }
      
    case .searchButtonTapped:
      linkNavigator.push(.search, nil)
      return .none
      
      /// 편집 버튼 탭 -> 편집 시트 표시
    case .editButtonTapped:
      state.editSheet = EditSheetFeature.State(link: nil)
      return .none
      
      /// 링크 롱프레스 -> 해당 링크의 편집 시트 표시
    case let .linkLongPressed(link):
      state.editSheet = EditSheetFeature.State(link: link)
      return .none
      
      /// 카테고리 시트 클릭 -> 카테고리 목록 요청
    case .bottomSheetButtonTapped:
      return .send(.fetchCategories)
      
      /// 카테고리 칩 선택 시 필터링
    case let .categoryChipList(.categoryTapped(category)):
      // 선택 상태 동기화
      state.selectedCategory = category
      state.categoryChipList.selectedCategory = category
      state.selectBottomSheet?.selectedCategory = category.categoryName
      
      // 필터링 반영
      if category.categoryName == "전체" {
        state.articleList.link = state.allLinks
      } else {
        state.articleList.link = state.allLinks.filter {
          $0.category?.categoryName == category.categoryName
        }
      }
      return .none
      
      /// 편집 시트 내부에서 닫기
    case .editSheet(.presented(.delegate(.dismissSheet))):
      state.editSheet = nil
      return .none
      
      /// 편집 시트 -> 이동하기
    case .editSheet(.presented(.delegate(.moveLink))):
      state.editSheet = nil
      if state.articleList.link.isEmpty {
        return .send(.showAlert(title: "이 카테고리에 이동할 링크가 없어요", tint: .alert))
      }
      let payload = LinkListPayload(
        links: state.articleList.link,
        categoryName: state.selectedCategory?.categoryName ?? "전체"
      )
      return .run { _ in
        linkNavigator.push(.moveLink, payload)
      }
      
    case let .moveToCategoryName(name):
      if let match = state.categoryChipList.categories.first(where: { $0.categoryName == name }) {
        state.selectedCategory = match
        state.categoryChipList.selectedCategory = match
        state.articleList.link = state.allLinks.filter {
          $0.category?.categoryName == name
        }
      } else {
        state.selectedCategory = nil
        state.categoryChipList.selectedCategory =
        state.categoryChipList.categories.first(where: { $0.categoryName == "전체" })
        state.articleList.link = state.allLinks
      }
      return .none
      
      /// 편집 시트 -> 삭제하기
    case .editSheet(.presented(.delegate(.deleteLink))):
      state.editSheet = nil
      if state.articleList.link.isEmpty {
        return .send(.showAlert(title: "이 카테고리에 삭제할 링크가 없어요", tint: .alert))
      }
      let payload = LinkListPayload(
        links: state.articleList.link,
        categoryName: state.selectedCategory?.categoryName ?? "전체"
      )
      return .run { _ in
        linkNavigator.push(.deleteLink, payload)
      }
      
      /// 알럿 띄우기
    case let .showAlert(title, tint):
      state.alert = .init(
        title: title,
        icon: tint == .info ? Image(icon: Icon.badgeCheck) : Image(icon: Icon.alertCircle),
        tint: tint
      )
      return .run { send in
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        await send(.hideAlertBanner)
      }
      
    case .hideAlertBanner:
      state.alert = nil
      return .none
      
      /// 카테고리 바텀시트에서 카테고리 선택
    case .selectBottomSheet(.presented(.delegate(.categorySelected(let name)))):
      if let name {
        if name == "전체" {
          state.selectedCategory = CategoryItem(categoryName: "전체", icon: .init(number: 0))
          state.articleList.link = state.allLinks
          state.categoryChipList.selectedCategory =
          state.categoryChipList.categories.first(where: { $0.categoryName == "전체" })
        } else {
          if let match = state.categoryChipList.categories.first(where: { $0.categoryName == name }) {
            state.selectedCategory = match
            state.categoryChipList.selectedCategory = match
          } else {
            state.selectedCategory = CategoryItem(categoryName: name, icon: .init(number: 1))
            state.categoryChipList.selectedCategory = nil
          }
          state.articleList.link = state.allLinks.filter { $0.category?.categoryName == name }
        }
      }
      return .none
      
      /// 카테고리 시트 닫기
    case .selectBottomSheet(.presented(.delegate(.dismiss))):
      state.selectBottomSheet = nil
      return .none
      
      /// 링크 롱프레스 -> 편집 시트 표시로 연결
    case let .articleList(.delegate(.longPressed(link))):
      return .send(.linkLongPressed(link))
      
    case .refresh:
      return .send(.fetchLinks)
      
    default:
      return .none
    }
  }
}

// MARK: - Data Reducer
private extension LinkListFeature {
  func dataReducer(state: inout State, action: Action) -> Effect<Action> {
    switch action {
      
      /// 링크 데이터 불러오기
    case .fetchLinks:
      return .run { (send: Send<Action>) in
        let result: TaskResult<[ArticleItem]> = await TaskResult {
          try swiftDataClient.fetchLinks()
        }
        switch result {
        case let .success(items):
          await send(.fetchLinksResponse(.success(items)))
        case let .failure(error):
          await send(.fetchLinksResponse(.failure(error)))
        }
      }
      
      /// 링크 데이터 성공적으로 로드됨
    case let .fetchLinksResponse(.success(items)):
      // 받은 데이터 정렬
      let sorted = items.sorted { $0.createAt > $1.createAt }
      state.allLinks = sorted
      state.articleList.sortOrder = .latest
      
      if let selected = state.selectedCategory, selected.categoryName != "전체" {
        state.articleList.link = sorted.filter { $0.category?.categoryName == selected.categoryName }
      } else if state.selectedCategory?.categoryName == "전체" {
        state.articleList.link = sorted
      } else if let chipSelected = state.categoryChipList.selectedCategory,
                chipSelected.categoryName != "전체" {
        state.selectedCategory = chipSelected
        state.articleList.link = sorted.filter {
          $0.category?.categoryName == chipSelected.categoryName
        }
      } else {
        state.articleList.link = sorted
      }
      
      if let selected = state.selectedCategory,
         let match = state.categoryChipList.categories.first(where: { $0.categoryName == selected.categoryName }) {
        state.categoryChipList.selectedCategory = match
      }
      return .none
      
      /// 데이터 로드 실패
    case let .fetchLinksResponse(.failure(error)):
      print("LinkList fetch failed:", error)
      return .none
      
      /// 카테고리 목록 불러오기
    case .fetchCategories:
      return .run { (send: Send<Action>) in
        let items = try swiftDataClient.fetchCategories()
        await send(.responseCategoryItems(items))
      }
      
      /// 카테고리 목록 로드 후 바텀시트 표시
    case .responseCategoryItems(let items):
      // 전체 + 최신순 구성
      let allCategory = CategoryProps(id: uuid(), title: "전체")
      let reversed = items.reversed()
      var props = reversed.map { CategoryProps(id: uuid(), title: $0.categoryName) }
      props.insert(allCategory, at: 0)
      let allCategories = IdentifiedArray(uniqueElements: props)
      
      let allChip = CategoryItem(categoryName: "전체", icon: .init(number: 0))
      let chipCategories = [allChip] + reversed.map {
        CategoryItem(categoryName: $0.categoryName, icon: $0.icon)
      }
      state.categoryChipList.categories = chipCategories
      
      if let selected = state.selectedCategory,
         let match = chipCategories.first(where: { $0.categoryName == selected.categoryName }) {
        state.categoryChipList.selectedCategory = match
      } else {
        // 혹시 매칭이 없으면 전체로
        state.selectedCategory = allChip
        state.categoryChipList.selectedCategory = allChip
      }
      
      let current = state.selectedCategory?.categoryName ?? "전체"
      state.selectBottomSheet = SelectBottomSheetFeature.State(
        categories: allCategories,
        selectedCategory: current
      )
      return .none
      
    default:
      return .none
    }
  }
}
