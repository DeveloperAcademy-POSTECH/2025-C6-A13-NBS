//
//  LinkListFeature.swift
//  Feature
//
//  Created by 이안 on 10/18/25.
//

import ComposableArchitecture
import Domain

@Reducer
struct LinkListFeature {
  @Dependency(\.swiftDataClient) var swiftDataClient
  
  @ObservableState
  struct State {
    var categoryChipList = CategoryChipFeature.State()
    var articleList = ArticleFilterFeature.State()
    var allLinks: [LinkItem] = []
    var showBottomSheet: Bool = false // 카테고리 선택 시트
    var selectedCategory: CategoryItem? = nil
    
    @Presents var editSheet: EditSheetFeature.State? // 링크 편집 시트
    @Presents var moveLink: MoveLinkFeature.State?
    @Presents var deleteLink: DeleteLinkFeature.State?
  }
  
  enum Action {
    /// 라이프사이클
    case onAppear
    
    /// 자식뷰
    case categoryChipList(CategoryChipFeature.Action)
    case articleList(ArticleFilterFeature.Action)
    
    /// UI 이벤트
    case bottomSheetButtonTapped(Bool)
    case linkLongPressed(LinkItem)
    case editButtonTapped
    
    /// 시트
    case editSheet(PresentationAction<EditSheetFeature.Action>)
    case moveLink(PresentationAction<MoveLinkFeature.Action>)
    case deleteLink(PresentationAction<DeleteLinkFeature.Action>)
    
    /// 데이터
    case fetchLinks
    case fetchLinksResponse(TaskResult<[LinkItem]>)
  
    case delegate(Delegate)
    enum Delegate {
      case openLinkDetail(LinkItem)
    }
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.categoryChipList, action: \.categoryChipList) {
      CategoryChipFeature()
    }
    
    Scope(state: \.articleList, action: \.articleList) {
      ArticleFilterFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in await send(.fetchLinks) }
        
      case .fetchLinks:
        return .run { send in
          await send(.fetchLinksResponse(TaskResult {
            try swiftDataClient.fetchLinkItem()
          }))
        }
        
      case let .fetchLinksResponse(.success(items)):
        state.allLinks = items
        state.articleList.link = items
        // 카테고리 필터 유지
        if let selected = state.selectedCategory {
          state.categoryChipList.selectedCategory = selected
          state.articleList.link = items.filter {
            $0.category?.categoryName == selected.categoryName
          }
        }
        return .none
        
      case let .fetchLinksResponse(.failure(error)):
        print("LinkList fetch failed:", error)
        return .none
        
        /// 카테고리 시트 토글
      case let .bottomSheetButtonTapped(value):
        state.showBottomSheet = value
        return .none
        
        /// 링크 길게 눌러서 편집 시트 열기
      case let .linkLongPressed(link):
          state.editSheet = EditSheetFeature.State(link: link)
          return .none
        
        /// 시트 열기
      case .editButtonTapped:
          state.editSheet = EditSheetFeature.State(link: nil)
          return .none
        
        /// 시트 닫기
      case .editSheet(.presented(.delegate(.dismissSheet))):
        state.editSheet = nil
        return .none
        
        /// 편집 시트 - 이동하기
      case let .editSheet(.presented(.delegate(.moveLink(link)))):
        state.moveLink = MoveLinkFeature.State(allLinks: state.allLinks)
        state.editSheet = nil
        return .none
        
      case .moveLink(.presented(.delegate(.dismiss))):
        state.moveLink = nil
        return .none
        
        /// 편집 시트 - 삭제하기
      case let .editSheet(.presented(.delegate(.deleteLink(link)))):
        state.deleteLink = DeleteLinkFeature.State(allLinks: state.allLinks)
        state.editSheet = nil
        return .none
        
      case .deleteLink(.presented(.delegate(.dismiss))):
        state.deleteLink = nil
        return .none
        
      case .editSheet:
        return .none
        
        /// 키테고리 칩 선택
      case let .categoryChipList(.categoryTapped(category)):
        if category.categoryName == "전체" {
          state.articleList.link = state.allLinks
        } else {
          state.articleList.link = state.allLinks.filter {
            guard let itemCategory = $0.category else { return false }
            return itemCategory.categoryName == category.categoryName
          }
        }
        return .none
        
        /// 링크 탭 -> 디테일 이동
      case let .articleList(.delegate(.openLinkDetail(link))):
        return .send(.delegate(.openLinkDetail(link)))
        
        /// 롱프레스 
      case let .articleList(.delegate(.longPressed(link))):
        return .send(.linkLongPressed(link))
        
      case .categoryChipList, .articleList, .delegate, .moveLink, .deleteLink:
        return .none
      }
    }
    .ifLet(\.$editSheet, action: \.editSheet) { EditSheetFeature() }
    .ifLet(\.$moveLink, action: \.moveLink) { MoveLinkFeature() }
    .ifLet(\.$deleteLink, action: \.deleteLink) { DeleteLinkFeature() }
  }
}
