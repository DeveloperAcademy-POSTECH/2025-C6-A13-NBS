//
//  HomeFeature.swift
//  Feature
//
//  Created by 홍 on 10/17/25.
//

import SwiftUI

import ComposableArchitecture
import Domain
import LinkNavigator

@Reducer
struct HomeFeature {
  
  @Dependency(\.clipboard) var clipboard
  @Dependency(\.swiftDataClient) var swiftDataClient
  @Dependency(\.linkNavigator) var linkNavigator
  
  @ObservableState
  struct State {
    var isCheckingClipboard = false
    var articleList = ArticleListFeature.State()
    var categoryList = CategoryListFeature.State()
    var alertBanner: AlertBannerState?
    var copiedLink: String?
    var myCategoryCollection = MyCategoryCollectionFeature.State()
    var lastShownClipboardLink: String?
    var showToast: Bool = false
    var deleteAlert: String? = nil
    var toastMessage: String = ""
    
    struct AlertBannerState: Equatable {
      let text: String
      let message: String
    }
  }
  
  enum Action {
    case onAppear
    case scenePhaseChangedToActive
    case clipboardResponded(String?)
    case dismissAlertBanner
    case alertBannerTapped
    case articleList(ArticleListFeature.Action) //TODO: 정말 필요한지 확인이 필요함
    case categoryList(CategoryListFeature.Action) //TODO: 정말 필요한지 확인이 필요함
    case floatingButtonTapped
    case fetchArticles
    case articlesResponse(Result<[ArticleItem], Error>)
    case searchButtonTapped
    case settingButtonTapped
    case logoButtonTapped
    case refresh
    case showToast(String)
    case showDeleteAlert(String)
    case hideDeleteAlert
    case hideToast
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.articleList, action: \.articleList) {
      ArticleListFeature()
    }
    
    Scope(state: \.categoryList, action: \.categoryList) {
      CategoryListFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(.fetchArticles)
        }
        
      case .scenePhaseChangedToActive:
        state.isCheckingClipboard = true
        return .run { send in
          await send(.clipboardResponded(clipboard.getString()))
        }
        
      case let .clipboardResponded(copiedText):
        state.isCheckingClipboard = false
        guard let copiedText,
              let url = URL(string: copiedText),
              let _ = url.host else {
          return .none
        }
        
        guard state.lastShownClipboardLink != copiedText else {
          return .none
        }
        
        state.alertBanner = .init(
          text: "복사한 링크 바로 추가하기",
          message: copiedText
        )
        state.copiedLink = copiedText
        state.lastShownClipboardLink = copiedText
        
        return .none
        
      case .dismissAlertBanner:
        state.alertBanner = nil
        return .none
        
      case .alertBannerTapped:
        if let link = state.copiedLink {
          linkNavigator.push(.addLink, CopiedLink(url: link))
        }
        state.alertBanner = nil
        return .none
        
      case .showToast(let message):
        state.showToast = true
        state.toastMessage = message
        return .run { send in
          try await Task.sleep(for: .seconds(2))
          await send(.hideToast)
        }
        
      case .hideToast:
        state.showToast = false
        state.toastMessage = ""
        return .none
        
      case .showDeleteAlert(let message):
        state.deleteAlert = message
        return .run { send in
          try await Task.sleep(for: .seconds(2))
          await send(.hideDeleteAlert)
        }
        
      case .hideDeleteAlert:
        state.deleteAlert = nil
        return .none
        
      case .fetchArticles:
        return .run { send in
          await send(.articlesResponse(Result { try swiftDataClient.fetchLinks() }))
        }
        
      case let .articlesResponse(.success(linkItems)):
        state.articleList.articles = linkItems
        return .none
        
      case .articlesResponse(.failure(let error)):
        print("Error fetching articles: \(error)")
        return .none
        
      case .refresh:
        return .run { send in
          await send(.fetchArticles)
        }
        
      case .floatingButtonTapped:
        return .run { _ in
          linkNavigator.push(.addLink, nil)
        }
        
      case .searchButtonTapped:
        linkNavigator.push(.search, nil)
        return .none
        
      case .settingButtonTapped:
        linkNavigator.push(.setting, nil)
        return .none
      
      case .logoButtonTapped:
        linkNavigator.replace([.onboardingService], nil)
        return .none
        
      case .categoryList, .articleList:
        return .none
      }
    }
  }
}
