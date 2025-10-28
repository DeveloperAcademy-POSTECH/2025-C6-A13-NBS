//
//  LinkListFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

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
    @Presents var moveLink: MoveLinkFeature.State?
    @Presents var deleteLink: DeleteLinkFeature.State?
    @Presents var selectBottomSheet: SelectBottomSheetFeature.State?
  }
  
  struct AlertBannerState: Equatable {
    let title: String
    let icon: String
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
    
    /// 시트 관련 액션
    case editSheet(PresentationAction<EditSheetFeature.Action>)
    case moveLink(PresentationAction<MoveLinkFeature.Action>)
    case deleteLink(PresentationAction<DeleteLinkFeature.Action>)
    case selectBottomSheet(PresentationAction<SelectBottomSheetFeature.Action>)
    case openDeleteLink
    case closeEditSheet
    case deleteLinksResponse(TaskResult<Void>)
    case hideAlertBanner
    
    /// 데이터 로드 관련
    case fetchLinks
    case fetchLinksResponse(TaskResult<[ArticleItem]>)
    case fetchCategories
    case responseCategoryItems([CategoryItem])
  
    case delegate(Delegate)
    enum Delegate {
      case openLinkDetail(ArticleItem)
    }
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
      .ifLet(\.$moveLink, action: \.moveLink) { MoveLinkFeature() }
      .ifLet(\.$deleteLink, action: \.deleteLink) { DeleteLinkFeature() }
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
      return .send(.fetchLinks)
      
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
      state.moveLink = MoveLinkFeature.State(allLinks: state.allLinks)
      state.editSheet = nil
      return .none
      
      /// 편집 시트 -> 삭제하기
    case .editSheet(.presented(.delegate(.deleteLink))):
      return .run { send in
        await send(.openDeleteLink)
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1초
        await send(.closeEditSheet)
      }
      
    case .hideAlertBanner:
      state.alert = nil
      return .none
      
    case .openDeleteLink:
      state.deleteLink = DeleteLinkFeature.State(allLinks: state.allLinks)
      return .none
      
    case .closeEditSheet:
      state.editSheet = nil
      return .none
      
      /// 이동 / 삭제 시트 닫기
    case .moveLink(.presented(.delegate(.dismiss))),
        .deleteLink(.presented(.delegate(.dismiss))):
      state.moveLink = nil
      state.deleteLink = nil
      return .none
      
      /// 카테고리 바텀시트에서 카테고리 선택
    case .selectBottomSheet(.presented(.delegate(.categorySelected(let name)))):
      if let name {
        if name == "전체" {
          // 필터 해제
          state.selectedCategory = nil
          state.articleList.link = state.allLinks
          
          // 칩 하이라이트는 전체 항목으로 맞춰주기
          if let allChip = state.categoryChipList.categories.first(where: { $0.categoryName == "전체" }) {
            state.categoryChipList.selectedCategory = allChip
          } else {
            // "전체" 칩이 별도로 없으면 하이라이트 해제
            state.categoryChipList.selectedCategory = nil
          }
        } else {
          // 현재 로드된 칩 목록에서 같은 이름의 카테고리 객체를 찾아 동기화
          if let match = state.categoryChipList.categories.first(where: { $0.categoryName == name }) {
            state.selectedCategory = match
            state.categoryChipList.selectedCategory = match
          } else {
            // 혹시 칩 목록에 아직 없으면 이름만으로 상태 유지
            state.selectedCategory = CategoryItem(categoryName: name, icon: .init(number: 1))
            state.categoryChipList.selectedCategory = nil
          }
          
          // 리스트 필터 적용
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
      
      /// 그 외 단순 전달 케이스
    case .categoryChipList, .articleList, .editSheet, .moveLink, .deleteLink, .selectBottomSheet, .delegate:
      return .none
      
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
        await send(.fetchLinksResponse(result))
      }
      
      /// 링크 데이터 성공적으로 로드됨
    case let .fetchLinksResponse(.success(items)):
      let sorted = items.sorted { $0.createAt > $1.createAt }
      state.allLinks = sorted
      state.articleList.link = sorted
      state.articleList.sortOrder = .latest
      
      if let selected = state.selectedCategory {
        // 목록도 필터
        state.articleList.link = sorted.filter { $0.category?.categoryName == selected.categoryName }
        // 칩 하이라이트 동기화 (동일 이름의 카테고리 객체로 교체)
        if let match = state.categoryChipList.categories.first(where: { $0.categoryName == selected.categoryName }) {
          state.categoryChipList.selectedCategory = match
          state.selectedCategory = match
        } else {
          // 칩 목록에 없으면 일단 하이라이트 해제
          state.categoryChipList.selectedCategory = nil
        }
      } else {
        // 전체 선택 상태라면 전체 칩에 하이라이트(있으면)
        if let allChip = state.categoryChipList.categories.first(where: { $0.categoryName == "전체" }) {
          state.categoryChipList.selectedCategory = allChip
        } else {
          state.categoryChipList.selectedCategory = nil
        }
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
      /// 전체 카테고리 + 실제 카테고리 목록 구성
      let allCategory = CategoryProps(id: uuid(), title: "전체")
      var categoryProps: [CategoryProps] = items.map { item in
        CategoryProps(id: uuid(), title: item.categoryName)
      }
      categoryProps.insert(allCategory, at: 0)
      let allCategories = IdentifiedArray(uniqueElements: categoryProps)
      
      /// 현재 선택된 카테고리명 기준으로 시트 선택상태 세팅
      let currentSelectedTitle = state.selectedCategory?.categoryName ?? "전체"
      
      /// 시트 상태 생성
      state.selectBottomSheet = SelectBottomSheetFeature.State(
        categories: allCategories,
        selectedCategory: currentSelectedTitle
      )
      return .none
      
    case .deleteLink(.presented(.delegate(.confirmDelete(let selected)))):
      return .run { send in
        await send(.deleteLinksResponse(TaskResult {
          try swiftDataClient.deleteLinks(selected)
        }))
      }

    case .deleteLinksResponse(.success):
      state.alert = .init(
        title: "\(state.deleteLink?.selectedLinks.count ?? 0)개의 링크를 삭제했어요",
        icon: "exclamationmark.circle"
      )

      return .merge(
        .send(.fetchLinks),
        .send(.deleteLink(.presented(.delegate(.dismiss)))),
        // ✅ 1.2초 후 배너 자동 숨김
        .run { send in
          try? await Task.sleep(nanoseconds: 3_000_000_000)
          await send(.hideAlertBanner)
        }
      )

    case .deleteLinksResponse(.failure(let error)):
      print("deleteLinks failed:", error)
      return .none
      
    default:
      return .none
    }
  }
}
