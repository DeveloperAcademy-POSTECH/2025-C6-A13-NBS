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
//    var showEditSheet: Bool = false // 링크 편집 시트
//    var selectedLink: LinkItem? = nil
    var selectedCategory: CategoryItem? = nil
    
    @Presents var editSheet: EditSheetFeature.State? // 링크 편집 시트
  }
  
  enum Action {
    case onAppear
    case categoryChipList(CategoryChipFeature.Action)
    case articleList(ArticleFilterFeature.Action)
    /// 카테고리
    case bottomSheetButtonTapped(Bool)
    
    /// 시트
    case linkLongPressed(LinkItem)
    case editButtonTapped
    case editSheet(PresentationAction<EditSheetFeature.Action>)
    
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
            try swiftDataClient.fetchLinks()
          }))
        }
        
      case let .fetchLinksResponse(.success(items)):
        state.allLinks = items
        state.articleList.articles = items
        
        if let selected = state.selectedCategory {
          state.categoryChipList.selectedCategory = selected
          state.articleList.articles = items.filter {
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
        print("이동하기: \(link?.title ?? "nil")")
        state.editSheet = nil
        // TODO: 이동용 시트/화면 push
        
        return .none
        
        /// 편집 시트 - 삭제하기
      case let .editSheet(.presented(.delegate(.deleteLink(link)))):
        print("삭제하기: \(link?.title ?? "nil")")
        // TODO: 삭제 확인 뷰 연결
        state.editSheet = nil
        return .none
        
      case .editSheet:
        return .none
        
//      case let .articleList(.delegate(.longPressed(link))):
//        state.selectedLink = link
//        state.showEditSheet = true
//        return .none
        
        /// 키테고리 칩 선택
      case let .categoryChipList(.categoryTapped(category)):
        if category.categoryName == "전체" {
          state.articleList.articles = state.allLinks
        } else {
          state.articleList.articles = state.allLinks.filter {
            guard let itemCategory = $0.category else { return false }
            return itemCategory.categoryName == category.categoryName
          }
        }
        return .none
        
        /// 링크 탭 -> 디테일 이동
      case let .articleList(.delegate(.openLinkDetail(link))):
        return .send(.delegate(.openLinkDetail(link)))
        
      case .bottomSheetButtonTapped(let value):
        state.showBottomSheet = value
        return .none
        
      case .categoryChipList, .articleList, .delegate:
        return .none
      }
    }
    .ifLet(\.$editSheet, action: \.editSheet) {
      EditSheetFeature()
    }
  }
}
